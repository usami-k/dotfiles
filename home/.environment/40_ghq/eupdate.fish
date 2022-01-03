#!/usr/bin/env fish

if command --query ghq
    function env_installed
        env GHQ_ROOT=$HOME/repos ghq list
    end

    for repo in (env_installed)
        pushd $HOME/repos/$repo
        git config rerere.enabled true
        popd
    end
end
