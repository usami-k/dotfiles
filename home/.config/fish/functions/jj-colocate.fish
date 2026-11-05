function jj-colocate -d 'Colocate jj in a git clone and track the default branch of origin' -a repo
    test -n "$repo"; or set repo .

    if test -d "$repo/.jj"
        echo "jj-colocate: $repo already uses jj." >&2
        return 1
    end
    if not test -d "$repo/.git"
        echo "jj-colocate: $repo is not a git work tree." >&2
        return 1
    end

    command jj --quiet git init --colocate "$repo"; or return

    set --local branch (git-default-branch "$repo"); or return
    if test -z "$branch"
        echo "jj-colocate: $repo has no default branch on origin; no bookmark tracked." >&2
        return 1
    end

    command jj --quiet -R "$repo" bookmark track "$branch@origin"; or return

    if contains -- $branch main master trunk
        command jj -R "$repo" config unset --repo 'revset-aliases."trunk()"'; or return
        echo "jj-colocate: $repo tracks $branch@origin"
    else
        echo "jj-colocate: $repo tracks $branch@origin; trunk() stays pinned to it"
    end
end
