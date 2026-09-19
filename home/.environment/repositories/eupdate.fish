#!/usr/bin/env fish

if type --query ghq-repos
    ghq-repos | while read repo
        echo "===" $repo
        pushd $repo
        if test -d .jj
            jj git fetch --no-pager
        else
            echo 'Git repository without jj'
            git fetch --prune
        end
        popd
    end
else
    echo 'Skip ghq'
end
