#!/usr/bin/env fish

function remote_default_commit --argument-names name
    command jj log --no-pager --color=never --no-graph -r "tracked_remote_bookmarks(exact:'$name', exact:'origin')" -T 'commit_id ++ "\n"'
end

function local_default_commit --argument-names name
    command jj bookmark list --no-pager --color=never "exact:$name" -T '
        if(!remote,
            if(!conflict && normal_target && !normal_target.conflict() && !normal_target.divergent(),
                normal_target.commit_id() ++ "\n",
                "unsafe\n"))
    '
end

function update_jj_repository
    set -l name (git-default-branch); or return
    set -l before
    if test -n "$name"
        set before (local_default_commit $name); or return
    end

    command jj git fetch --no-pager; or return

    if test -z "$name"
        echo 'repositories: skipped working copy update: origin does not report a default branch'
        return 0
    end
    if test (count (remote_default_commit $name)) -eq 0
        echo "repositories: skipped working copy update: default branch $name is not tracked from origin"
        return 0
    end

    set -l after (local_default_commit $name); or return
    set -l remote (remote_default_commit $name); or return
    if test (count $after) -ne 1; or test (count $remote) -ne 1; or test "$after" != "$remote"
        echo "repositories: skipped working copy update: $name must match one tracked $name@origin without conflicts"
        return 0
    end

    set -l working_copy (command jj log --no-pager --color=never --no-graph -r @ -T '
        if(parents.len() == 1, parents.first().commit_id(), "none") ++ "\n" ++
        if(empty && description == "" && !conflict && !divergent && !immutable &&
            bookmarks.len() == 0 && tags.len() == 0 && working_copies.len() <= 1 &&
            self.contained_in("heads(all())"),
            "idle",
            "busy") ++ "\n"
    '); or return
    if test (count $working_copy) -ne 2
        echo "repositories: could not determine whether the working copy can move to $name" >&2
        return 1
    end
    set -l parent $working_copy[1]
    set -l activity $working_copy[2]

    if test "$parent" = "$after"
        echo "repositories: working copy is already based on $name"
        return 0
    end
    if test "$before" = "$after"
        echo "repositories: skipped working copy update: $name did not move in this fetch"
        return 0
    end
    if test "$parent" != "$before"
        echo "repositories: skipped working copy update: working copy was not on the previous $name"
        return 0
    end
    if test "$activity" != idle
        echo 'repositories: skipped working copy update: working copy is not an unnamed empty leaf'
        return 0
    end

    command jj new "$after" --no-pager; or return
    echo "repositories: working copy updated to $name ($after)"

    set -l emptiness (command jj log --no-pager --color=never --no-graph -r @ -T 'if(empty, "empty", "changed")'); or return
    if test "$emptiness" != empty
        echo "repositories: working copy picked up files after moving to $name; check jj st" >&2
        set -ga repositories_needing_attention $PWD
    end
end

if not type --query ghq-repos; or not type --query git-default-branch
    echo 'Skip ghq'
    exit 0
end

set -g repositories_needing_attention
set -l repos (ghq-repos); or exit
for repo in $repos
    echo "===" $repo
    pushd "$repo"; or exit
    if test -d .jj
        update_jj_repository; or exit
    else
        echo 'Git repository without jj'
        command git fetch --prune; or exit
    end
    popd; or exit
end

if test (count $repositories_needing_attention) -gt 0
    echo 'repositories: working copies need attention:' >&2
    printf '  %s\n' $repositories_needing_attention >&2
    exit 1
end
