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
