#!/usr/bin/env fish

set -g script (path resolve $argv[1])
set -g driver (path resolve $argv[2])
set -g fixture (mktemp -d); or exit
set -g fish_bin (status fish-path)
set -g base_path /usr/bin /bin /usr/sbin /sbin
set -g passed 0
function cleanup --on-event fish_exit
    command rm -rf -- "$fixture"
end

mkdir -p "$fixture/bin" "$fixture/state/tracked-configs" "$fixture/state/tracked-stubs"
printf '%s\n' "#!$fish_bin --no-config" \
    'string join " " -- $argv >>"$TEST_CALLS"' \
    'if contains -- --dry-run $argv' \
    '    printf "%s\n" "$TEST_PREVIEW_OUTPUT"' \
    '    exit $TEST_PREVIEW_STATUS' \
    end \
    'printf "%s\n" "$TEST_PRUNE_OUTPUT"' \
    'exit $TEST_PRUNE_STATUS' >"$fixture/bin/mise"
printf '%s\n' "#!$fish_bin --no-config" \
    'if test "$TEST_UNMOUNT_AFTER_PREVIEW" = 1; and test -f "$TEST_CALLS"' \
    '    exit 0' \
    end \
    'printf "%s\n" "$TEST_MOUNTS"' >"$fixture/bin/mount"
chmod +x "$fixture/bin/mise" "$fixture/bin/mount"

set -gx MISE_STATE_DIR "$fixture/state"
set -gx TEST_CALLS "$fixture/calls"

function reset_case
    command rm -f "$TEST_CALLS" "$fixture/state/tracked-configs/entry" "$fixture/state/tracked-stubs/entry"
    set -gx TEST_PREVIEW_OUTPUT 'mise scanning tracked configs done'
    set -gx TEST_PRUNE_OUTPUT 'mise prune complete'
    set -gx TEST_PREVIEW_STATUS 0
    set -gx TEST_PRUNE_STATUS 0
    set -gx TEST_MOUNTS 'disk on /Volumes/Available (apfs, local)'
    set -gx TEST_UNMOUNT_AFTER_PREVIEW 0
end

function expect --argument-names label expected_status expected_calls
    command env PATH=(string join : "$fixture/bin" $base_path) "$fish_bin" --no-config "$script" >"$fixture/output" 2>&1
    set -l actual_status $status
    set -l actual_calls 0
    if test -f "$TEST_CALLS"
        set actual_calls (count (command cat "$TEST_CALLS"))
    end
    if test $actual_status -ne $expected_status; or test $actual_calls -ne $expected_calls
        printf 'FAIL: %s (status %s, calls %s)\n' "$label" $actual_status $actual_calls >&2
        command cat "$fixture/output" >&2
        exit 1
    end
    if test $expected_calls -eq 2
        if test (string join , (command cat "$TEST_CALLS")) != 'prune --tools --dry-run,prune --tools --yes'
            echo 'FAIL: unexpected mise commands' >&2
            exit 1
        end
    end
    set -g passed (math $passed + 1)
end

reset_case
expect 'no candidates succeeds' 0 2
reset_case
set -gx TEST_PREVIEW_OUTPUT 'mise python@3.12.15 [dryrun] remove old installation'
expect 'candidate proceeds to prune' 0 2
for warning in 'mise WARN error loading tracked config' 'mise warn: unreadable lockfile' 'WARNING: incomplete scan' 'mise ERROR incomplete scan'
    reset_case
    set -gx TEST_PREVIEW_OUTPUT "$warning"
    expect 'preview warning blocks pruning despite exit zero' 1 1
end
reset_case
set -gx TEST_PREVIEW_STATUS 7
expect 'preview failure is preserved' 7 1
reset_case
set -gx TEST_PREVIEW_STATUS 130
expect 'preview interruption is preserved' 130 1
reset_case
set -gx TEST_PRUNE_STATUS 9
expect 'prune failure is preserved' 9 2
reset_case
set -gx TEST_PRUNE_OUTPUT 'mise WARN failed to remove installation'
expect 'prune warning fails the step' 1 2
reset_case
ln -s /Volumes/Available/deleted/mise.toml "$fixture/state/tracked-configs/entry"
expect 'deleted config on mounted disk is allowed' 0 2
reset_case
ln -s /Volumes/Missing/project/mise.toml "$fixture/state/tracked-configs/entry"
expect 'unmounted config volume blocks even the preview' 1 0
reset_case
ln -s '/Volumes/Missing disk/project/tool' "$fixture/state/tracked-stubs/entry"
expect 'unmounted stub volume blocks pruning' 1 0
reset_case
ln -s '/Volumes/Available [disk]/project/mise.toml' "$fixture/state/tracked-configs/entry"
set -gx TEST_MOUNTS 'disk on /Volumes/Available [disk] (apfs, local)'
expect 'mount names with spaces and regex characters work' 0 2
reset_case
ln -s /Volumes/Available/project/mise.toml "$fixture/state/tracked-configs/entry"
set -gx TEST_UNMOUNT_AFTER_PREVIEW 1
expect 'volume disappearing after preview blocks pruning' 1 1
reset_case
ln -s "$fixture/deleted/mise.toml" "$fixture/state/tracked-configs/entry"
expect 'deleted local config does not block pruning' 0 2
reset_case
set -lx XDG_STATE_HOME "$fixture/xdg"
mkdir -p "$XDG_STATE_HOME/mise/tracked-configs"
ln -s /Volumes/Missing/project/mise.toml "$XDG_STATE_HOME/mise/tracked-configs/entry"
expect 'MISE_STATE_DIR takes precedence over XDG_STATE_HOME' 0 2
set -e MISE_STATE_DIR
command rm -f "$TEST_CALLS"
expect 'XDG_STATE_HOME tracking is inspected' 1 0
set -gx MISE_STATE_DIR "$fixture/state"
set -e XDG_STATE_HOME

command env PATH=(string join : $base_path) "$fish_bin" --no-config "$script" >"$fixture/output" 2>&1
if test $status -ne 0; or not string match --quiet 'Skip mise' <"$fixture/output"
    echo 'FAIL: missing mise should skip successfully' >&2
    exit 1
end
set -g passed (math $passed + 1)

# Exercise the real driver only with fixture steps: never run real updates.
mkdir -p "$fixture/environment/mise-cleanup" "$fixture/environment/repositories"
cp "$driver" "$fixture/environment/eupdate.fish"
printf '%s\n' '#!/bin/sh' 'exit 0' >"$fixture/environment/repositories/eupdate.fish"
printf '%s\n' '#!/bin/sh' 'echo "fixture cleanup"' 'exit 1' >"$fixture/environment/mise-cleanup/eupdate.fish"
chmod +x "$fixture/environment/"*/eupdate.fish
"$fish_bin" --no-config "$fixture/environment/eupdate.fish" full >"$fixture/output" 2>&1
if test $status -ne 1; or not string match --quiet '*RUN END mode=full result=partial*failed_steps=mise-cleanup' <"$fixture/output"
    echo 'FAIL: full must report cleanup failure as partial' >&2
    command cat "$fixture/output" >&2
    exit 1
end
set -l repositories_line (command grep -n 'STEP END name=repositories' "$fixture/output" | cut -d: -f1)
set -l cleanup_line (command grep -n 'STEP START name=mise-cleanup' "$fixture/output" | cut -d: -f1)
if test $repositories_line -ge $cleanup_line
    echo 'FAIL: cleanup must follow repositories' >&2
    exit 1
end
set -g passed (math $passed + 1)
"$fish_bin" --no-config "$fixture/environment/eupdate.fish" light >"$fixture/output" 2>&1
if test $status -ne 0; or string match --quiet '*mise-cleanup*' <"$fixture/output"
    echo 'FAIL: light must not run cleanup' >&2
    exit 1
end
set -g passed (math $passed + 1)

echo "PASS: $passed mise cleanup scenarios"
