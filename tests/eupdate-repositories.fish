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

for name in clean dirty untracked described bookmarked local-work main-ahead untracked-main missing-main child other-workspace shared merge failed-fetch older stale
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
command jj -R "$fixture/older" new 'root()' >/dev/null; or exit
command jj -R "$fixture/stale" new 'root()' >/dev/null; or exit
expect_unchanged stale "$script"

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

for name in dirty untracked described bookmarked local-work main-ahead untracked-main missing-main child shared merge older
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

function new_origin --argument-names origin trunk
    command jj git init --colocate "$origin" >/dev/null; or exit
    command mkdir "$origin/generated"; or exit
    printf 'output\n' >"$origin/generated/.gitignore"
    printf 'old\n' >"$origin/content.txt"
    command jj -R "$origin" describe -m initial >/dev/null; or exit
    command jj -R "$origin" bookmark set $trunk -r @ >/dev/null; or exit
end

function clone_origin --argument-names origin name
    command jj git clone --colocate "$origin" "$fixture/$name" >/dev/null 2>&1; or exit
    for bookmark in $argv[3..]
        command jj -R "$fixture/$name" bookmark track $bookmark@origin >/dev/null 2>&1; or exit
    end
end

new_origin "$fixture/master-origin" master
clone_origin "$fixture/master-origin" master master
command jj -R "$fixture/master" new master >/dev/null; or exit
command jj -R "$fixture/master-origin" new -m updated >/dev/null; or exit
printf 'new\n' >"$fixture/master-origin/content.txt"
command jj -R "$fixture/master-origin" bookmark set master -r @ >/dev/null; or exit
run_update "$fixture/master" "$script"
or begin
    command cat "$fixture/output" >&2
    exit 1
end
assert_equal (revision "$fixture/master" @-) (revision "$fixture/master-origin" master) 'master working copy moves to latest master'
assert_equal (command grep -c 'No matching bookmarks' "$fixture/output") 0 'repositories without main do not warn'
set -g passed (math $passed + 1)

new_origin "$fixture/feature-origin" main
command jj -R "$fixture/feature-origin" new -m feature >/dev/null; or exit
printf 'feature\n' >"$fixture/feature-origin/feature.txt"
command jj -R "$fixture/feature-origin" bookmark set feature -r @ >/dev/null; or exit
clone_origin "$fixture/feature-origin" merged-feature main feature
command jj -R "$fixture/merged-feature" new feature >/dev/null; or exit
clone_origin "$fixture/feature-origin" leftover main
command jj -R "$fixture/leftover" new main >/dev/null; or exit
printf 'build output\n' >"$fixture/leftover/generated/output"
command jj -R "$fixture/feature-origin" bookmark set master -r main >/dev/null; or exit
clone_origin "$fixture/feature-origin" several main master
command jj -R "$fixture/several" new main >/dev/null; or exit
command jj -R "$fixture/feature-origin" bookmark delete master >/dev/null; or exit
command jj -R "$fixture/feature-origin" new main feature -m merged >/dev/null; or exit
command rm -r "$fixture/feature-origin/generated"; or exit
command jj -R "$fixture/feature-origin" bookmark set main -r @ >/dev/null; or exit
set -l merged (revision "$fixture/feature-origin" main); or exit

expect_unchanged merged-feature "$script"
expect_unchanged several "$script"

if run_update "$fixture/leftover" "$script"
    echo 'FAIL: picked up files must fail the repositories step' >&2
    exit 1
end
assert_equal (revision "$fixture/leftover" @-) "$merged" 'leftover working copy still moves to main'
assert_equal (command grep -c 'picked up files after moving to main' "$fixture/output") 1 'picked up files are reported'
set -g passed (math $passed + 1)

new_origin "$fixture/rewritten-origin" main
clone_origin "$fixture/rewritten-origin" force-pushed main
command jj -R "$fixture/force-pushed" new main >/dev/null; or exit
command jj -R "$fixture/rewritten-origin" new 'root()' -m replacement >/dev/null; or exit
printf 'replacement\n' >"$fixture/rewritten-origin/content.txt"
command jj -R "$fixture/rewritten-origin" bookmark set main --allow-backwards -r @ >/dev/null; or exit
expect_unchanged force-pushed "$script"
assert_equal (revision "$fixture/force-pushed" @-) (revision "$fixture/force-pushed" 'root()') 'force push leaves the working copy on the old parent'

echo "PASS: $passed repository update scenarios"
