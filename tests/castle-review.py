"""Integration tests: real temporary Git repositories, no network or user state."""

import fcntl
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "home/.environment/homeshick/review.py"


class CastleReview(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.home = Path(self.temporary.name)
        self.repo = self.home / ".homesick/repos/example"
        self.repo.mkdir(parents=True)
        self.env = dict(os.environ, HOME=str(self.home), XDG_STATE_HOME=str(self.home / "state"),
                        GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM="1")
        self.git("init", "-q")
        self.git("config", "user.name", "Review Test")
        self.git("config", "user.email", "review@example.invalid")
        self.base = self.add_commit("baseline")

    def git(self, *args):
        return subprocess.check_output(["git", "-C", str(self.repo), *args], env=self.env,
                                       text=True, stderr=subprocess.PIPE).strip()

    def add_commit(self, text):
        (self.repo / "content").write_text(text)
        self.git("add", "content")
        self.git("commit", "-q", "-m", text)
        return self.git("rev-parse", "HEAD")

    def cli(self, *args, ok=True):
        result = subprocess.run([sys.executable, str(SCRIPT), *args], env=self.env,
                                capture_output=True, text=True)
        self.assertEqual(result.returncode, 0 if ok else 1, result.stdout + result.stderr)
        return result.stdout + result.stderr

    def initialize(self):
        self.cli("init", "example", "--base", self.base, "--note", "Known reviewed boundary for fixture")

    def state_file(self):
        return next((self.home / "state/eupdate/castle-review").glob("*.json"))

    def state(self):
        return json.loads(self.state_file().read_text())

    def review(self, start, target, *runtime, ok=True):
        return self.cli("review", "example", "--from", start, "--to", target,
                        "--summary", "Read the actual diff and reported its effects", *runtime, ok=ok)

    def test_first_run_does_not_assume_review_or_create_state(self):
        for _ in range(2):
            self.assertIn("baseline=unset content=unconfirmed", self.cli("status"))
        self.assertFalse((self.home / "state").exists())

    def test_noop_runs_preserve_pending_even_after_push(self):
        self.initialize()
        target = self.add_commit("local change")
        # An up-to-date upstream does not imply content was reviewed.
        self.git("update-ref", "refs/remotes/origin/main", target)
        self.git("config", "branch.master.remote", "origin")
        before = self.state_file().read_bytes()
        for _ in range(2):
            output = self.cli("status")
            self.assertIn("content_pending=1", output)
            self.assertIn(target, output)
        self.assertEqual(self.state_file().read_bytes(), before)

    def test_reviewed_content_and_multiple_runtime_waits_are_independent(self):
        self.initialize()
        target = self.add_commit("backup change")
        self.review(self.base, target, "--awaiting", "Run the changed backup next time",
                    "--awaiting", "Check the other machine without private castle")
        state = self.state()
        self.assertEqual(state["reviewed"], target)
        self.assertEqual(len(state["reviews"]), 1)
        for _ in range(2):
            self.assertIn("content_pending=0 runtime_pending=2", self.cli("status", "--summary"))
        item = state["runtime"][0]
        self.cli("verify", "example", item["id"], "--evidence", "Subsequent backup log: changed implementation succeeded")
        self.assertIn("content_pending=0 runtime_pending=1", self.cli("status"))
        self.assertEqual(self.state()["reviewed"], target)
        self.assertEqual(self.state()["runtime"][0]["status"], "verified")
        self.cli("verify", "example", item["id"], "--evidence", "duplicate", ok=False)

    def test_snapshot_review_keeps_newer_commit_unreviewed(self):
        self.initialize()
        snapshot = self.add_commit("snapshot")
        later = self.add_commit("another chat")
        self.review(self.base, snapshot, "--verified", "Documentation only; no runtime change")
        output = self.cli("status")
        self.assertIn("content_pending=1", output)
        self.assertIn(later, output)
        self.assertEqual(self.state()["reviewed"], snapshot)
        before = self.state_file().read_bytes()
        self.review(self.base, later, "--verified", "stale writer", ok=False)
        self.assertEqual(self.state_file().read_bytes(), before)

    def test_dirty_files_remain_untouched_and_do_not_disappear_into_receipt(self):
        self.initialize()
        target = self.add_commit("committed")
        (self.repo / "content").write_text("uncommitted")
        (self.repo / "new").write_text("untracked")
        before = self.git("status", "--porcelain")
        self.review(self.base, target, "--awaiting", "Runtime still pending")
        self.assertEqual(self.git("status", "--porcelain"), before)
        self.assertEqual((self.repo / "content").read_text(), "uncommitted")

    def test_rewritten_history_never_advances_or_resets_state(self):
        self.initialize()
        target = self.add_commit("reviewed")
        self.review(self.base, target, "--verified", "fixture check")
        self.git("checkout", "-q", "--orphan", "rewritten")
        replacement = self.add_commit("replacement")
        before = self.state_file().read_bytes()
        self.assertIn("not an ancestor", self.cli("status", ok=False))
        self.review(target, replacement, "--verified", "invalid", ok=False)
        self.cli("init", "example", "--base", replacement, "--note", "reset", ok=False)
        self.assertEqual(self.state_file().read_bytes(), before)

    def test_missing_commit_and_corrupt_state_are_errors(self):
        self.initialize()
        state = self.state()
        state["reviewed"] = "f" * 40
        self.state_file().write_text(json.dumps(state))
        self.cli("status", ok=False)
        self.state_file().write_text("broken JSON")
        self.assertIn("preserve and inspect", self.cli("status", ok=False))
        self.assertEqual(self.state_file().read_text(), "broken JSON")

    def test_state_writer_lock_prevents_lost_updates(self):
        self.initialize()
        target = self.add_commit("change")
        before = self.state_file().read_bytes()
        with open(str(self.state_file()) + ".lock", "w") as stream:
            fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
            self.assertIn("busy", self.review(self.base, target, "--awaiting", "check", ok=False))
        self.assertEqual(self.state_file().read_bytes(), before)

    def test_structurally_invalid_state_cannot_drop_runtime_waits(self):
        self.initialize()
        target = self.add_commit("change")
        self.review(self.base, target, "--awaiting", "must remain pending")
        state = self.state()
        state["runtime"][0]["review_id"] = "missing receipt"
        damaged = json.dumps(state)
        self.state_file().write_text(damaged)
        self.assertIn("invalid review state", self.cli("status", ok=False))
        self.cli("verify", "example", state["runtime"][0]["id"], "--evidence", "cannot bypass damage", ok=False)
        self.assertEqual(self.state_file().read_text(), damaged)

    def test_machine_local_state_does_not_acknowledge_another_machine(self):
        self.initialize()
        old = self.env["XDG_STATE_HOME"]
        self.env["XDG_STATE_HOME"] = str(self.home / "other-machine-state")
        self.assertIn("baseline=unset", self.cli("status"))
        self.env["XDG_STATE_HOME"] = old
        self.assertIn("content_pending=0", self.cli("status"))

    def test_bad_explanations_and_abbreviated_ids_do_not_write(self):
        self.initialize()
        target = self.add_commit("change")
        before = self.state_file().read_bytes()
        self.review(self.base, target[:8], "--verified", "not a snapshot", ok=False)
        result = subprocess.run([sys.executable, str(SCRIPT), "review", "example", "--from", self.base,
                                 "--to", target, "--summary", " ", "--awaiting", "check"],
                                env=self.env, capture_output=True)
        self.assertEqual(result.returncode, 2)
        self.assertEqual(self.state_file().read_bytes(), before)

    def test_eupdate_noop_prints_pending_and_final_summary_without_ack(self):
        self.initialize()
        target = self.add_commit("pending update")
        self.git("update-ref", "refs/remotes/origin/main", target)
        environment = self.home / ".environment"
        (environment / "homeshick").mkdir(parents=True)
        for relative in ("eupdate.fish", "functions.fish", "homeshick/eupdate.fish", "homeshick/review.py"):
            shutil.copy2(ROOT / "home/.environment" / relative, environment / relative)
        bin_dir = self.home / "bin"
        bin_dir.mkdir()
        (bin_dir / "homeshick").write_text("#!/bin/sh\nexit 0\n")
        (bin_dir / "uv").write_text('#!/bin/sh\nshift 6\nexec "' + sys.executable + '" "$@"\n')
        for name in ("uv", "homeshick"):
            (bin_dir / name).chmod(0o755)
        self.env["PATH"] = str(bin_dir) + os.pathsep + os.environ["PATH"]
        before = self.state_file().read_bytes()
        for _ in range(2):
            result = subprocess.run([shutil.which("fish"), "--no-config", str(environment / "eupdate.fish"), "light"],
                                    env=self.env, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertEqual(result.stdout.count("content_pending=1 runtime_pending=0"), 2)
            self.assertIn("### RUN END mode=light result=success", result.stdout)
        self.assertEqual(self.state_file().read_bytes(), before)
        self.state_file().write_text("corrupt")
        result = subprocess.run([shutil.which("fish"), "--no-config", str(environment / "eupdate.fish"), "light"],
                                env=self.env, capture_output=True, text=True)
        self.assertEqual(result.returncode, 1)
        self.assertIn("result=partial", result.stdout)
        self.assertIn("castle-review", result.stdout)


if __name__ == "__main__":
    unittest.main()
