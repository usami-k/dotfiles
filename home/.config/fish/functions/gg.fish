function gg -d 'Switch to a jj workspace'
    if not command -sq fzf
        echo 'Error: gg needs fzf command.' >&2
        return 1
    end

    if not test -d .jj
        echo 'Not a jj repository' >&2
        return 1
    end

    jj workspace list -T 'name ++ "\n"' | fzf | read --local name

    if test -n "$name"
        cd (jj workspace root --name $name)
    end

    if status is-interactive
        commandline -f repaint
    end
end
