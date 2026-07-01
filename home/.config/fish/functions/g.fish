function __g_prefer_home_repos_path -a candidate -d 'Prefer the ~/repos symlink path over its physical target'
    set --local home_repos "$HOME/repos"

    if test -d "$home_repos"; and command -sq realpath
        set --local physical_home_repos (realpath "$home_repos")

        if test "$candidate" = "$physical_home_repos"
            set candidate "$home_repos"
        else if string match -q "$physical_home_repos/*" "$candidate"
            set candidate (string replace -- "$physical_home_repos/" "$home_repos/" "$candidate")
        end
    end

    printf '%s\n' "$candidate"
end

function __g_collect_candidates -d 'Collect ghq repositories and configured extra paths'
    set --local candidates

    if test -r ~/.config/fish/g_paths
        while read --local candidate
            if test -d "$candidate"
                set --append candidates "$candidate"
            end
        end < ~/.config/fish/g_paths
    end

    if command -sq ghq
        for candidate in (ghq list --full-path)
            set --append candidates (__g_prefer_home_repos_path "$candidate")
        end
    end

    printf '%s\n' $candidates
end

function g -d 'Change directory to select from ghq list and configured extra paths'
    if not command -sq fzf
        echo 'Error: g needs fzf command.' >&2
        return 1
    end

    set --local query (string join ' ' -- $argv)
    set --local selected (__g_collect_candidates | fzf --query "$query")

    if test -n "$selected"
        cd "$selected"
    end

    if status is-interactive
        commandline -f repaint
    end
end
