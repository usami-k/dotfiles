function ghq-repos -d 'List ghq repositories as logical ~/repos full paths'
    if not command -sq ghq
        echo 'Error: ghq-repos needs ghq command.' >&2
        return 1
    end

    set --local paths (command ghq list --full-path $argv)
    set --local ghq_status $status

    test (count $paths) -gt 0; and __prefer_home_symlink_path $paths

    return $ghq_status
end
