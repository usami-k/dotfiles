function g -d 'Change directory to select from ghq list'
    if not command -sq ghq
        echo 'Error: g needs ghq command.' >&2
        return 1
    end

    if not command -sq fzf
        echo 'Error: g needs fzf command.' >&2
        return 1
    end

    set --local query (string join ' ' -- $argv)

    ghq list --full-path | fzf --query "$query" | read --local selected

    if test -n "$selected"
        cd "$selected"
    end

    if status is-interactive
        commandline -f repaint
    end
end
