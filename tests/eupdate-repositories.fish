#!/usr/bin/env fish

set -l script (path resolve $argv[1])
if not test -f "$script"
    echo 'Usage: fish tests/eupdate-repositories.fish <repositories/eupdate.fish>' >&2
    exit 64
end

set -g fixture (mktemp -d); or exit
function cleanup --on-event fish_exit
    command rm -rf -- "$fixture"
end

set -gx JJ_CONFIG "$fixture/config.toml"
set -gx XDG_CONFIG_HOME "$fixture/config"
printf '%s\n' '[user]' 'name = "eupdate test"' 'email = "eupdate@example.invalid"' '[signing]' 'behavior = "drop"' >"$JJ_CONFIG"
set -g passed 0

function revision --argument-names repo revset
    command jj -R "$repo" log --no-graph -r "$revset" -T 'commit_id ++ "\n"'
end

function working_change --argument-names repo
    command jj --ignore-working-copy -R "$repo" log --no-graph -r @ -T change_id
end

function assert_equal --argument-names actual expected label
    if test "$actual" != "$expected"
        printf 'FAIL: %s\nexpected: %s\nactual: %s\n' "$label" "$expected" "$actual" >&2
        command cat "$fixture/output" >&2
        exit 1
    end
end

function run_update --argument-names repo script
    command env EUPDATE_TEST_REPO="$repo" fish --no-config --command '
        function ghq-repos
            printf "%s\n" "$EUPDATE_TEST_REPO"
        end
        source "$argv[1]"
    ' "$script" >"$fixture/output" 2>&1
end

function expect_unchanged --argument-names name script
    set -l repo "$fixture/$name"
    set -l before (working_change "$repo"); or exit
    run_update "$repo" "$script"
    or begin
        command cat "$fixture/output" >&2
        exit 1
    end
    assert_equal (working_change "$repo") "$before" "$name keeps its working copy"
    set -g passed (math $passed + 1)
end

command jj git init --colocate "$fixture/origin" >/dev/null; or exit
printf 'old\n' >"$fixture/origin/content.txt"
command jj -R "$fixture/origin" describe -m initial >/dev/null; or exit
command jj -R "$fixture/origin" bookmark set main -r @ >/dev/null; or exit

for name in clean dirty untracked described bookmarked local-work main-ahead untracked-main missing-main child other-workspace shared merge failed-fetch
    command jj git clone --colocate -b main "$fixture/origin" "$fixture/$name" >/dev/null; or exit
    command jj -R "$fixture/$name" bookmark track main@origin >/dev/null; or exit
end

printf 'in progress\n' >"$fixture/dirty/content.txt"
printf 'new work\n' >"$fixture/untracked/new.txt"
command jj -R "$fixture/described" describe -m 'planned work' >/dev/null; or exit
command jj -R "$fixture/bookmarked" bookmark set feature -r @ >/dev/null; or exit
printf 'local work\n' >"$fixture/local-work/content.txt"
command jj -R "$fixture/local-work" new >/dev/null; or exit
printf 'local main\n' >"$fixture/main-ahead/content.txt"
command jj -R "$fixture/main-ahead" bookmark set main -r @ >/dev/null; or exit
command jj -R "$fixture/main-ahead" new >/dev/null; or exit
command jj -R "$fixture/untracked-main" bookmark untrack main@origin >/dev/null; or exit
command jj -R "$fixture/missing-main" bookmark delete main >/dev/null; or exit
command jj -R "$fixture/child" new --no-edit -m child >/dev/null; or exit
command jj -R "$fixture/other-workspace" workspace add "$fixture/separate" -r @- >/dev/null; or exit
set -l separate_before (revision "$fixture/separate" @); or exit
command jj -R "$fixture/shared" workspace add "$fixture/shared-other" -r @- >/dev/null; or exit
command jj -R "$fixture/shared-other" edit default@ >/dev/null; or exit
command jj -R "$fixture/merge" new --no-edit -m side >/dev/null; or exit
command jj -R "$fixture/merge" new @ 'description(exact:"side\n")' >/dev/null; or exit
command jj -R "$fixture/failed-fetch" git remote set-url origin "$fixture/missing-origin" >/dev/null; or exit

command jj -R "$fixture/origin" new >/dev/null; or exit
printf 'new\n' >"$fixture/origin/content.txt"
command jj -R "$fixture/origin" describe -m updated >/dev/null; or exit
command jj -R "$fixture/origin" bookmark set main -r @ >/dev/null; or exit
set -l latest (revision "$fixture/origin" main); or exit

run_update "$fixture/clean" "$script"
or begin
    command cat "$fixture/output" >&2
    exit 1
end
assert_equal (revision "$fixture/clean" @-) "$latest" 'clean working copy moves to latest main'
assert_equal (command cat "$fixture/clean/content.txt") new 'updated files reach working copy'
set -g passed (math $passed + 1)
expect_unchanged clean "$script"

for name in dirty untracked described bookmarked local-work main-ahead untracked-main missing-main child shared merge
    expect_unchanged "$name" "$script"
end
assert_equal (command cat "$fixture/dirty/content.txt") 'in progress' 'tracked edits are preserved'
assert_equal (command cat "$fixture/untracked/new.txt") 'new work' 'new files are preserved'

run_update "$fixture/other-workspace" "$script"
or begin
    command cat "$fixture/output" >&2
    exit 1
end
assert_equal (revision "$fixture/other-workspace" @-) "$latest" 'default workspace moves to main'
assert_equal (revision "$fixture/separate" @) "$separate_before" 'separate workspace stays in place'
assert_equal (command cat "$fixture/separate/content.txt") old 'separate workspace files stay unchanged'
set -g passed (math $passed + 1)

set -l failed_before (revision "$fixture/failed-fetch" @); or exit
if run_update "$fixture/failed-fetch" "$script"
    echo 'FAIL: fetch failure must fail the repositories step' >&2
    exit 1
end
assert_equal (revision "$fixture/failed-fetch" @) "$failed_before" 'fetch failure keeps its working copy'
set -g passed (math $passed + 1)

command jj git clone --colocate -b main "$fixture/origin" "$fixture/conflicted-main" >/dev/null; or exit
command jj -R "$fixture/conflicted-main" bookmark track main@origin >/dev/null; or exit
command jj -R "$fixture/origin" new main- -m alternative >/dev/null; or exit
printf 'alternative\n' >"$fixture/origin/content.txt"
command jj -R "$fixture/origin" new main @ -m conflicted >/dev/null; or exit
command jj -R "$fixture/origin" bookmark set main -r @ >/dev/null; or exit
expect_unchanged conflicted-main "$script"

echo "PASS: $passed repository update scenarios"
