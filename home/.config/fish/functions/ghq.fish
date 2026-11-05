function ghq --wraps ghq -d 'Run ghq and colocate jj in repositories that ghq get cloned'
    if test "$argv[1]" != get; or not command -sq jj
        command ghq $argv
        return
    end

    set --local before (command ghq list --full-path)
    command ghq $argv
    set --local ghq_status $status

    for repo in (command ghq list --full-path)
        contains -- $repo $before; and continue
        test -d "$repo/.git"; or continue
        test -d "$repo/.jj"; and continue
        jj-colocate $repo
    end

    return $ghq_status
end
