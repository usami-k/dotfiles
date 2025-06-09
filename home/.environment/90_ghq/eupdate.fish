#!/usr/bin/env fish

if command --query ghq
    function env_personal
        ghq list --full-path usami-k/
    end

    for repo in (env_personal)
        pushd $repo
        git pull --quiet
        popd
    end
end
