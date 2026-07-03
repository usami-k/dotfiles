function __ghq_prefer_home_repos_path -a candidate -d 'Prefer the ~/repos symlink path over its physical target'
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

function ghq-repos -d 'List ghq repositories as logical ~/repos full paths'
    if not command -sq ghq
        echo 'Error: ghq-repos needs ghq command.' >&2
        return 1
    end

    command ghq list --full-path $argv | while read --local candidate
        __ghq_prefer_home_repos_path "$candidate"
    end

    return $pipestatus[1]
end
