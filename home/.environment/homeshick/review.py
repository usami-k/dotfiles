"""Local, explicit review receipts for homeshick castles (standard library only)."""

import argparse
import contextlib
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import uuid


class ReviewError(Exception):
    pass


def git(repo, *args):
    result = subprocess.run(
        ["git", "--no-pager", "-C", str(repo), *args],
        text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        env=dict(os.environ, GIT_OPTIONAL_LOCKS="0"),
    )
    if result.returncode:
        raise ReviewError(result.stderr.strip() or "git command failed")
    return result.stdout.strip()


def commit(repo, value):
    if not re.fullmatch(r"[0-9a-f]{40}|[0-9a-f]{64}", value):
        raise ReviewError("use the full commit ID printed by status")
    if git(repo, "rev-parse", "--verify", value + "^{commit}") != value:
        raise ReviewError("not a commit: " + value)
    return value


def ancestor(repo, older, newer):
    # merge-base exits 1 for non-ancestry; other failures must remain errors.
    result = subprocess.run(
        ["git", "-C", str(repo), "merge-base", "--is-ancestor", older, newer],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
    )
    if result.returncode not in (0, 1):
        raise ReviewError(result.stderr.strip())
    return result.returncode == 0


def now():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def state_path(repo):
    root = Path(os.environ.get("XDG_STATE_HOME") or str(Path.home() / ".local/state"))
    if not root.is_absolute():
        raise ReviewError("XDG_STATE_HOME must be an absolute, machine-local path")
    key = hashlib.sha256(str(repo).encode()).hexdigest()
    return root / "eupdate/castle-review" / (key + ".json")


def require(condition):
    if not condition:
        raise ValueError("invalid review record")


def load(repo):
    path = state_path(repo)
    if not path.exists():
        return None
    try:
        state = json.loads(path.read_text())
        require(state["version"] == 1 and state["repo"] == str(repo))
        require(isinstance(state["reviews"], list))
        require(isinstance(state["runtime"], list))
        require(isinstance(state["baseline_note"], str) and state["baseline_note"].strip())
        require(isinstance(state["baseline_at"], str))
        require(re.fullmatch(r"[0-9a-f]{40}|[0-9a-f]{64}", state["reviewed"]))
        previous = None
        receipts = {}
        for receipt in state["reviews"]:
            require(all(isinstance(receipt[key], str) and receipt[key].strip()
                        for key in ("id", "from", "to", "summary", "at")))
            require(previous is None or receipt["from"] == previous)
            require(receipt["verified"] is None or (isinstance(receipt["verified"], str) and receipt["verified"].strip()))
            require(receipt["id"] not in receipts)
            receipts[receipt["id"]] = receipt
            previous = receipt["to"]
        require(previous is None or state["reviewed"] == previous)
        ids = set()
        for item in state["runtime"]:
            require(all(isinstance(item[key], str) for key in ("id", "from", "to", "note", "created_at")))
            receipt = receipts[item["review_id"]]
            require(item["from"] == receipt["from"] and item["to"] == receipt["to"])
            require(item["note"].strip() and item["id"] not in ids)
            ids.add(item["id"])
            require(item["status"] in ("pending", "verified"))
            if item["status"] == "verified":
                require(isinstance(item["evidence"], str) and item["evidence"].strip())
                require(isinstance(item["verified_at"], str) and item["verified_at"])
        return state
    except (ValueError, KeyError, TypeError) as error:
        raise ReviewError("invalid review state; preserve and inspect " + str(path)) from error


@contextlib.contextmanager
def editing(repo):
    path = state_path(repo)
    path.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    # Keep the lock file: removing it could give concurrent writers different locks.
    fd = os.open(str(path) + ".lock", os.O_CREAT | os.O_RDWR, 0o600)
    try:
        try:
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as error:
            raise ReviewError("review state is busy; retry after the other writer finishes") from error
        yield
    finally:
        os.close(fd)


def save(repo, state):
    path = state_path(repo)
    fd, temporary = tempfile.mkstemp(dir=path.parent, prefix=".review-")
    try:
        with os.fdopen(fd, "w") as stream:
            json.dump(state, stream, ensure_ascii=False, indent=2)
            stream.write("\n")
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def repository(name):
    if not name or Path(name).name != name or name in (".", ".."):
        raise ReviewError("specify a castle name, not a path")
    repo = (Path.home() / ".homesick/repos" / name).resolve()
    if not repo.is_dir() or Path(git(repo, "rev-parse", "--show-toplevel")).resolve() != repo:
        raise ReviewError("not a castle repository: " + name)
    return repo


def show(repo, summary=False):
    head = git(repo, "rev-parse", "--verify", "HEAD")
    state = load(repo)
    if state is None:
        print(f"castle review {repo.name}: baseline=unset content=unconfirmed head={head}")
        if not summary:
            print("  Choose the last known reviewed commit; do not silently initialize at HEAD.")
            print("  castle-review init CASTLE --base FULL_COMMIT --note 'baseline scope and reason'")
        return
    base = commit(repo, state["reviewed"])
    pending = [item for item in state["runtime"] if item["status"] == "pending"]
    continuous = ancestor(repo, base, head)
    count = git(repo, "rev-list", "--count", base + ".." + head) if continuous else "unknown"
    print(f"castle review {repo.name}: content_pending={count} runtime_pending={len(pending)} from={base} to={head}")
    for item in pending:
        print(f"  runtime pending id={item['id']} range={item['from']}..{item['to']} note={json.dumps(item['note'], ensure_ascii=False)}")
    if not continuous:
        raise ReviewError("reviewed commit is not an ancestor of HEAD; inspect history, do not advance the baseline")
    if count != "0" and not summary:
        print(git(repo, "log", "--stat", "--date=iso-local", "--format=%H %ad %s", base + ".." + head))


def change(repo, args):
    with editing(repo):
        state = load(repo)
        if args.action == "init":
            if state is not None:
                raise ReviewError("baseline already exists; init cannot reset it")
            base = commit(repo, args.base)
            if not ancestor(repo, base, git(repo, "rev-parse", "HEAD")):
                raise ReviewError("baseline must be an ancestor of HEAD")
            state = dict(version=1, repo=str(repo), reviewed=base,
                         baseline_note=args.note, baseline_at=now(), reviews=[], runtime=[])
        else:
            if state is None:
                raise ReviewError("baseline is unset; initialize an explicit review boundary first")
            if args.action == "review":
                base, target = commit(repo, args.start), commit(repo, args.to)
                if base != state["reviewed"]:
                    raise ReviewError("review position changed; rerun status before recording")
                if base == target or not ancestor(repo, base, target):
                    raise ReviewError("review must advance through a continuous, nonempty range")
                if not ancestor(repo, target, git(repo, "rev-parse", "HEAD")):
                    raise ReviewError("target is no longer in HEAD history; inspect before recording")
                receipt = dict(id=uuid.uuid4().hex, **{"from": base}, to=target,
                               summary=args.summary, at=now(), verified=args.verified)
                state["reviews"].append(receipt)
                for note in args.awaiting or []:
                    state["runtime"].append(dict(id=uuid.uuid4().hex, **{"from": base},
                        to=target, review_id=receipt["id"], note=note, created_at=now(), status="pending"))
                state["reviewed"] = target
            elif args.action == "verify":
                matches = [item for item in state["runtime"] if item["id"] == args.id]
                if len(matches) != 1 or matches[0]["status"] != "pending":
                    raise ReviewError("specify an existing pending runtime ID")
                matches[0].update(status="verified", evidence=args.evidence, verified_at=now())
        save(repo, state)
    print("castle review recorded: " + args.action + " " + repo.name)


def nonempty(value):
    if not value.strip():
        raise argparse.ArgumentTypeError("a nonempty explanation is required")
    return value


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="action", required=True)
    status = commands.add_parser("status", help="show unreviewed commits and runtime waits without acknowledging them")
    status.add_argument("castle", nargs="?")
    status.add_argument("--summary", action="store_true")
    init = commands.add_parser("init", help="set an explicit historical review boundary once")
    init.add_argument("castle")
    init.add_argument("--base", required=True)
    init.add_argument("--note", type=nonempty, required=True)
    review = commands.add_parser("review", help="record content review after reporting its findings")
    review.add_argument("castle")
    review.add_argument("--from", dest="start", required=True)
    review.add_argument("--to", required=True)
    review.add_argument("--summary", type=nonempty, required=True)
    runtime = review.add_mutually_exclusive_group(required=True)
    runtime.add_argument("--verified", type=nonempty, help="runtime evidence or explanation that runtime checking is unnecessary")
    runtime.add_argument("--awaiting", type=nonempty, action="append", help="remaining runtime check; repeat for separate checks")
    verify = commands.add_parser("verify", help="resolve one runtime wait with evidence")
    verify.add_argument("castle")
    verify.add_argument("id")
    verify.add_argument("--evidence", type=nonempty, required=True)
    args = parser.parse_args()
    try:
        if args.action == "status":
            names = [args.castle] if args.castle else sorted(
                entry.name for entry in (Path.home() / ".homesick/repos").iterdir() if entry.is_dir())
            errors = False
            for name in names:
                try:
                    show(repository(name), args.summary)
                except (ReviewError, OSError) as error:
                    print(f"castle review ERROR {name}: {error}", file=sys.stderr)
                    errors = True
            return int(errors)
        change(repository(args.castle), args)
        return 0
    except (ReviewError, OSError) as error:
        print("castle review ERROR: " + str(error), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
