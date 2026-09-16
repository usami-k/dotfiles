function __prefer_home_symlink_path -d 'Rewrite physical paths back to their ~/... symlink form'
    set --local paths $argv

    for logical in "$HOME/repos" "$HOME/workspaces"
        test -d "$logical"; or continue
        command -sq realpath; or break

        set --local physical (command realpath "$logical")
        test "$physical" = "$logical"; and continue

        set --local prefix (string escape --style=regex -- "$physical")
        set paths (string replace --regex -- "^$prefix(?=/|\$)" "$logical" $paths)
    end

    test (count $paths) -gt 0; and printf '%s\n' $paths
end
