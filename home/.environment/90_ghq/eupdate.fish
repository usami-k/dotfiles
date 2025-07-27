#!/usr/bin/env fish

if type --query ghq
    for repo in (ghq list --full-path)
        pushd $repo
        git fetch --all --prune
        popd
    end
else
    echo 'Skip ghq'
end
