function __prefer_home_symlink_path -d 'Rewrite physical paths back to their ~/... symlink form'
    set --local logical_roots "$HOME/repos" "$HOME/workspaces"

    set --local physicals
    set --local logicals

    if command -sq realpath
        for logical in $logical_roots
            test -d "$logical"; or continue
            set --local physical (command realpath "$logical")
            test "$physical" = "$logical"; and continue
            set --append physicals "$physical"
            set --append logicals "$logical"
        end
    end

    for candidate in $argv
        if test (count $physicals) -gt 0
            for i in (seq (count $physicals))
                if test "$candidate" = "$physicals[$i]"
                    set candidate "$logicals[$i]"
                    break
                else if string match -q "$physicals[$i]/*" "$candidate"
                    set candidate (string replace -- "$physicals[$i]/" "$logicals[$i]/" "$candidate")
                    break
                end
            end
        end
        printf '%s\n' "$candidate"
    end
end
