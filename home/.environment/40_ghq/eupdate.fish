#!/usr/bin/env fish

if command --query ghq
    function env_installed
        ghq list
    end

    for repo in (env_installed)
        pushd $HOME/repos/$repo
        git config rerere.enabled true
        popd
    end
end

if command --query ghq
    function env_personal
        ghq list usami-k/
    end

    for repo in (env_personal)
        pushd $HOME/repos/$repo
        git pull --quiet
        popd
    end
end
