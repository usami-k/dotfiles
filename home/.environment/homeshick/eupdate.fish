#!/usr/bin/env fish

source (dirname (status filename))/../functions.fish; or exit

if not type --query homeshick
    echo 'Skip homeshick'
    exit 0
end

for repo_dir in ~/.homesick/repos/*/
    set -l castle (basename $repo_dir)
    pushd $repo_dir; or exit
    set -l upstream_before (git rev-parse --quiet --verify '@{upstream}' 2>/dev/null)
    eupdate_run homeshick --batch pull $castle
    set -l upstream_after (git rev-parse --quiet --verify '@{upstream}' 2>/dev/null)
    if test -n "$upstream_before" -a -n "$upstream_after" -a "$upstream_before" != "$upstream_after"
        echo "incoming commits $castle $upstream_before..$upstream_after"
        eupdate_run git --no-pager log --stat --date=iso-local --format='%h %ad %s' $upstream_before..$upstream_after
    end
    popd; or exit
end

function eupdate_check_link_parents --argument-names repo_dir
    set -l unsafe 0
    command git -C "$repo_dir" ls-files --recurse-submodules -z -- home/ | while read --null --local tracked
        set -l relative (string sub --start 6 -- "$tracked")
        set -l source_parent (path resolve -- (path dirname -- "$repo_dir/$tracked"))
        set -l target_parent (path resolve -- (path dirname -- "$HOME/$relative"))
        if not set -q source_parent[1]; or not set -q target_parent[1]
            printf 'homeshick: cannot resolve link parents: %s\n' "$relative" >&2
            set unsafe 1
        else if test "$source_parent" = "$target_parent"
            printf 'homeshick: refusing force link through a directory symlink into its source: %s\n' "$HOME/$relative" >&2
            set unsafe 1
        end
    end
    set -l codes $pipestatus
    if test $codes[1] -ne 0
        echo "homeshick: cannot list tracked files (exit=$codes[1]): $repo_dir" >&2
        return 1
    end
    return $unsafe
end

set -l link_safe true
for repo_dir in ~/.homesick/repos/*/
    if not eupdate_run eupdate_check_link_parents "$repo_dir"
        set link_safe false
    end
end
if $link_safe
    eupdate_run homeshick --batch --force link
end

for repo_dir in ~/.homesick/repos/*/
    set -l castle (basename $repo_dir)
    pushd $repo_dir; or exit
    eupdate_run homeshick --batch check $castle
    popd; or exit
end

exit $eupdate_exit_code
