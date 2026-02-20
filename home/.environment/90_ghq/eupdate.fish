#!/usr/bin/env fish

if type --query ghq
    for repo in (ghq list --full-path)
        echo "## " $repo
        pushd $repo
        if test -d .jj
            jj git fetch
        else
            git fetch --prune
        end
        popd
    end
else
    echo 'Skip ghq'
end
