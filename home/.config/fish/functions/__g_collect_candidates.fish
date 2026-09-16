function __g_collect_candidates -d 'Collect candidate paths: g_paths + ghq repos + jj workspaces'
    set --local candidates

    if test -r ~/.config/fish/g_paths
        while read --local candidate
            if test -d "$candidate"
                set --append candidates "$candidate"
            end
        end < ~/.config/fish/g_paths
    end

    set --local all_paths
    command -sq ghq; and set all_paths (command ghq list --full-path)

    if test -d ~/workspaces
        set --append all_paths (command find -H ~/workspaces -type d -name .jj -prune -print0 | path dirname -z)
    end

    test (count $all_paths) -gt 0; and set --append candidates (__prefer_home_symlink_path $all_paths)

    printf '%s\n' $candidates | command awk 'NF && !seen[$0]++'
end
