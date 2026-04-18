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
        set --append candidates (ghq list --full-path)
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
