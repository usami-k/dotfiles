function __g_collect_candidates -d 'Collect candidate paths: g_paths + ghq repos + jj extra workspaces'
    set --local candidates

    if test -r ~/.config/fish/g_paths
        while read --local candidate
            if test -d "$candidate"
                set --append candidates "$candidate"
            end
        end < ~/.config/fish/g_paths
    end

    if command -sq ghq
        set --local home_repos "$HOME/repos"
        set --local physical_home_repos
        if test -d "$home_repos"; and command -sq realpath
            set physical_home_repos (command realpath "$home_repos")
        end

        set --local ghq_paths (command ghq list --full-path)

        set --local jj_repos
        for p in $ghq_paths
            if test -d "$p/.jj"
                set --append jj_repos "$p"
            end
        end

        set --local ws_roots
        if test (count $jj_repos) -gt 0
            set --local tmpdir (command mktemp -d)
            set --local i 0
            for repo in $jj_repos
                set i (math $i + 1)
                begin
                    __g_jj_workspaces_of "$repo" > "$tmpdir/$i.txt"
                end &
            end
            wait
            set ws_roots (command cat $tmpdir/*.txt 2>/dev/null | string match -rv '^$')
            command rm -rf $tmpdir
        end

        set --local all_paths $ghq_paths $ws_roots
        if test -n "$physical_home_repos"; and test (count $all_paths) -gt 0
            set all_paths (string replace -- "$physical_home_repos/" "$home_repos/" $all_paths)
            for i in (seq (count $all_paths))
                test $all_paths[$i] = $physical_home_repos; and set all_paths[$i] $home_repos
            end
        end
        set --append candidates $all_paths
    end

    printf '%s\n' $candidates | command awk 'NF && !seen[$0]++'
end
