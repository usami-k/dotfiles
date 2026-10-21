function gg -d 'Switch to a jj workspace'
    if not command -sq fzf
        echo 'Error: gg needs fzf command.' >&2
        return 1
    end

    if not test -d .jj
        echo 'Not a jj repository' >&2
        return 1
    end

    __gg_collect_candidates | fzf | string split -f1 ' ' | read --local name

    if test -n "$name"
        cd (__prefer_home_symlink_path (jj workspace root --name $name))
    end

    if status is-interactive
        commandline -f repaint
    end
end
