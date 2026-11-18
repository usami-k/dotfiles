#!/usr/bin/env fish

set -g script (path resolve $argv[1])
set -g homeshick_bin (command -s homeshick); or exit 1
# Avoid user toolchain proxies when the fixture changes HOME and PATH.
set -g git_bin (command env PATH=/opt/homebrew/bin:/usr/bin:/bin which git); or exit 1
set -g fish_bin (status fish-path)
set -g fixture (mktemp -d); or exit 1
function cleanup --on-event fish_exit
    command rm -rf -- "$fixture"
end

set -g test_home "$fixture/home with spaces"
set -g repos "$test_home/.homesick/repos"
set -g first "$repos/example"
set -g second "$repos/second"
mkdir -p "$first/home/.codex/guidance" "$second/home/.environment/mise-cleanup" "$test_home/.codex" "$test_home/.environment" "$fixture/bin"
for name in browser.md development.md xcode.md
    printf '%s\n' "original $name" >"$first/home/.codex/guidance/$name"
end
printf '%s\n' '#!/bin/sh' 'exit 0' >"$second/home/.environment/mise-cleanup/eupdate.fish"
chmod +x "$second/home/.environment/mise-cleanup/eupdate.fish"
printf '%s\n' new-config >"$first/home/.new-config"
printf '%s\n' castle-config >"$first/home/.existing-config"
printf '%s\n' user-config >"$test_home/.existing-config"
for castle in "$first" "$second"
    git init --quiet "$castle"; or exit 1
    git -C "$castle" add home; or exit 1
end
ln -s ../.homesick/repos/example/home/.codex/guidance "$test_home/.codex/guidance"
ln -s ../.homesick/repos/second/home/.environment/mise-cleanup "$test_home/.environment/mise-cleanup"

# Reproduce the old destructive behavior using only disposable files.
command env HOME="$test_home" "$homeshick_bin" --batch --force link second >"$fixture/reproduction" 2>&1
or begin
    cat "$fixture/reproduction" >&2
    exit 1
end
set -l cleanup_script "$second/home/.environment/mise-cleanup/eupdate.fish"
if not test -L "$cleanup_script"; or test (readlink "$cleanup_script") != eupdate.fish; or test -e "$cleanup_script"
    echo 'FAIL: original force-link behavior did not reproduce the self-link' >&2
    cat "$fixture/reproduction" >&2
    ls -l "$cleanup_script" >&2
    exit 1
end
command rm "$cleanup_script"
printf '%s\n' '#!/bin/sh' 'exit 0' >"$cleanup_script"
chmod +x "$cleanup_script"

# Exercise the real eupdate step and real link implementation; pull/check
# are isolated stubs, so this test never fetches or contacts a remote.
printf '%s\n' "#!$fish_bin --no-config" \
    'string join " " -- $argv >>"$TEST_CALLS"' \
    'if contains -- link $argv; or contains -- symlink $argv' \
    '    exec "$TEST_HOMESHICK" $argv' \
    end \
    'exit 0' >"$fixture/bin/homeshick"
chmod +x "$fixture/bin/homeshick"
printf '%s\n' "#!$fish_bin --no-config" \
    'if test "$TEST_LIST_FAILURE" = 1; and contains -- ls-files $argv; exit 42; end' \
    'exec "$TEST_GIT" $argv' >"$fixture/bin/git"
chmod +x "$fixture/bin/git"

function run_step --argument-names list_failure
    printf '' >"$fixture/calls"
    command env HOME="$test_home" TEST_HOMESHICK="$homeshick_bin" TEST_GIT="$git_bin" TEST_CALLS="$fixture/calls" TEST_LIST_FAILURE="$list_failure" PATH=(string join : "$fixture/bin" $PATH) "$fish_bin" --no-config "$script" >"$fixture/output" 2>&1
end

run_step 0
if test $status -ne 1; or not string match --quiet '*refusing force link through a directory symlink*' <"$fixture/output"
    echo 'FAIL: unsafe directory links must fail before linking' >&2
    cat "$fixture/output" >&2
    exit 1
end
if string match --quiet '* link*' <"$fixture/calls"
    echo 'FAIL: force link ran despite unsafe directory links' >&2
    exit 1
end
for castle in "$first" "$second"
    git -C "$castle" diff --quiet; or exit 1
end

# Use homeshick's normal layout: real directories and per-file symlinks.
command rm "$test_home/.codex/guidance" "$test_home/.environment/mise-cleanup"
mkdir "$test_home/.codex/guidance" "$test_home/.environment/mise-cleanup"
for iteration in 1 2
    run_step 0
    or begin
        cat "$fixture/output" >&2
        exit 1
    end
    for name in browser.md development.md xcode.md
        set -l source_file "$first/home/.codex/guidance/$name"
        if test -L "$source_file"; or test (cat "$source_file") != "original $name"
            echo "FAIL: directory link damaged $name on run $iteration" >&2
            exit 1
        end
    end
    if test -L "$cleanup_script"; or not test -x "$cleanup_script"; or test (string join , (cat "$cleanup_script")) != '#!/bin/sh,exit 0'
        echo "FAIL: executable source changed on run $iteration" >&2
        exit 1
    end
    if not test -L "$test_home/.new-config"; or test (cat "$test_home/.new-config") != new-config
        echo 'FAIL: missing files must still be linked' >&2
        exit 1
    end
    if not test -L "$test_home/.existing-config"; or test (cat "$test_home/.existing-config") != castle-config
        echo 'FAIL: force must still replace conflicting existing files' >&2
        exit 1
    end
    for castle in "$first" "$second"
        if not git -C "$castle" diff --quiet
            echo "FAIL: linking modified castle sources on run $iteration" >&2
            git -C "$castle" diff >&2
            exit 1
        end
    end
end

run_step 1
if test $status -ne 1; or not string match --quiet '*cannot list tracked files*' <"$fixture/output"; or string match --quiet '* link*' <"$fixture/calls"
    echo 'FAIL: listing failures must block force link' >&2
    cat "$fixture/output" >&2
    exit 1
end

echo 'PASS: force-link reproduction, unsafe-directory and listing-failure guards, two normal force-link runs (source contents, executable mode, new links, conflict replacement)'
