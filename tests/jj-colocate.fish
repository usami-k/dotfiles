#!/usr/bin/env fish

set -l functions_dir (path resolve $argv[1])
if not test -f "$functions_dir/jj-colocate.fish"
    echo 'Usage: fish tests/jj-colocate.fish <fish functions directory>' >&2
    exit 64
end
source $functions_dir/git-default-branch.fish
source $functions_dir/jj-colocate.fish

set -g fixture (mktemp -d); or exit
function cleanup --on-event fish_exit
    command rm -rf -- "$fixture"
end

set -gx JJ_CONFIG "$fixture/config.toml"
set -gx XDG_CONFIG_HOME "$fixture/config"
set -gx GIT_CONFIG_GLOBAL /dev/null
set -gx GIT_CONFIG_NOSYSTEM 1
set -gx GIT_AUTHOR_NAME 'jj-colocate test'
set -gx GIT_AUTHOR_EMAIL jj-colocate@example.invalid
set -gx GIT_COMMITTER_NAME $GIT_AUTHOR_NAME
set -gx GIT_COMMITTER_EMAIL $GIT_AUTHOR_EMAIL
printf '%s\n' '[user]' 'name = "jj-colocate test"' 'email = "jj-colocate@example.invalid"' '[signing]' 'behavior = "drop"' >"$JJ_CONFIG"
set -g passed 0

function fail --argument-names label
    printf 'FAIL: %s\n' "$label" >&2
    command cat "$fixture/output" >&2
    exit 1
end

function make_origin --argument-names name branch
    command git init --quiet -b $branch "$fixture/$name-origin"; or exit
    command git -C "$fixture/$name-origin" commit --quiet --allow-empty -m initial; or exit
    command git clone --quiet "$fixture/$name-origin" "$fixture/$name"; or exit
end

function tracked_commit --argument-names repo branch
    command jj -R "$repo" log --no-graph -r "tracked_remote_bookmarks(exact:'$branch', exact:'origin')" -T 'commit_id ++ "\n"'
end

function pinned_trunk --argument-names repo
    command jj -R "$repo" config list --repo 'revset-aliases."trunk()"' 2>/dev/null
end

function expect_colocated --argument-names name branch expected_trunk
    set -l repo "$fixture/$name"
    jj-colocate "$repo" >"$fixture/output" 2>&1; or fail "$name colocates"
    test -n "$(tracked_commit $repo $branch)"; or fail "$name tracks $branch@origin"
    set -l trunk (pinned_trunk $repo)
    test "$trunk" = "$expected_trunk"; or fail "$name leaves trunk() as '$expected_trunk', got '$trunk'"
    set -g passed (math $passed + 1)
end

make_origin main-default main
expect_colocated main-default main ''

make_origin master-default master
expect_colocated master-default master ''

make_origin develop-default develop
expect_colocated develop-default develop 'revset-aliases."trunk()" = "develop@origin"'

jj-colocate "$fixture/main-default" >"$fixture/output" 2>&1; and fail 'already colocated repository is refused'
set passed (math $passed + 1)

command mkdir "$fixture/plain"
jj-colocate "$fixture/plain" >"$fixture/output" 2>&1; and fail 'directory without git is refused'
test -d "$fixture/plain/.jj"; and fail 'directory without git stays untouched'
set passed (math $passed + 1)

command git init --quiet -b main "$fixture/no-origin"; or exit
jj-colocate "$fixture/no-origin" >"$fixture/output" 2>&1; and fail 'repository without origin reports failure'
test -d "$fixture/no-origin/.jj"; or fail 'repository without origin is still colocated'
set passed (math $passed + 1)

echo "ok: $passed jj-colocate cases"
