#!/usr/bin/env fish

if type --query ghq
    ghq list --full-path | while read repo
        echo "===" $repo
        pushd $repo
        if test -d .jj
            jj git fetch --no-pager
        else
            git fetch --prune
        end
        popd
    end
else
    echo 'Skip ghq'
end
