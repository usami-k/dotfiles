function git-default-branch -d 'Print the branch that HEAD of origin points to' -a repo
    test -n "$repo"; or set repo .

    set --local head (command git -C "$repo" ls-remote --symref origin HEAD); or return
    string replace --filter --regex '^ref: refs/heads/(.+)\tHEAD$' '$1' -- $head
    return 0
end
