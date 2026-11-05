#!/usr/bin/env fish

if not type --query homeshick
    echo 'Skip homeshick'
    exit 0
end

for repo_dir in ~/.homesick/repos/*/
    set -l castle (basename $repo_dir)
    pushd $repo_dir; or exit
    set -l upstream_before (git rev-parse --quiet --verify '@{upstream}' 2>/dev/null)
    homeshick --batch pull $castle
    set -l upstream_after (git rev-parse --quiet --verify '@{upstream}' 2>/dev/null)
    if test -n "$upstream_before" -a -n "$upstream_after" -a "$upstream_before" != "$upstream_after"
        echo "incoming commits $castle $upstream_before..$upstream_after"
        git --no-pager log --stat --date=iso-local --format='%h %ad %s' $upstream_before..$upstream_after
    end
    popd
end

homeshick --batch --force link

for repo_dir in ~/.homesick/repos/*/
    set -l castle (basename $repo_dir)
    pushd $repo_dir; or exit
    homeshick --batch check $castle
    popd
end
