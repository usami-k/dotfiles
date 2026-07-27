function g -d 'Change directory to select from ghq list, jj workspaces, and configured extra paths'
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
