#!/usr/bin/env fish

function update_jj_repository
    command jj git fetch --no-pager; or return

    set -l main_commit (command jj bookmark list --no-pager --color=never exact:main -T '
        if(!remote,
            if(!conflict && normal_target && !normal_target.conflict() && !normal_target.divergent(),
                normal_target.commit_id() ++ "\n",
                "unsafe\n"))
    '); or return
    set -l remote_main (command jj log --no-pager --color=never --no-graph -r 'tracked_remote_bookmarks(exact:"main", exact:"origin")' -T 'commit_id ++ "\n"'); or return
    if test (count $main_commit) -ne 1; or test (count $remote_main) -ne 1; or test "$main_commit" != "$remote_main"
        echo 'repositories: skipped main update: main must match one tracked main@origin without conflicts'
        return 0
    end

    set -l state (command jj log --no-pager --color=never --no-graph -r @ -T '
        if(parents.len() == 1 && parents.first().contained_in("bookmarks(exact:main)"),
            "current",
            if(empty && description == "" && !conflict && !divergent && !immutable &&
                bookmarks.len() == 0 && tags.len() == 0 && working_copies.len() <= 1 &&
                parents.len() == 1 && parents.first().contained_in("::bookmarks(exact:main)") &&
                self.contained_in("heads(all())"),
                "ready",
                "busy"))
    '); or return

    switch $state
        case current
            echo 'repositories: working copy is already based on main'
        case ready
            command jj new "$main_commit" --no-pager; or return
            echo "repositories: working copy updated to main ($main_commit)"
        case busy
            echo 'repositories: skipped main update: working copy is not an unnamed empty leaf on older main'
        case '*'
            echo 'repositories: could not determine whether the working copy can move to main' >&2
            return 1
    end
end

if not type --query ghq-repos
    echo 'Skip ghq'
    exit 0
end

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
