#!/usr/bin/env fish

if command --query ghq
    function env_personal
        ghq list --full-path usami-k/
    end

    for repo in (env_personal)
        pushd $repo
        git pull --quiet
        aicommits hook install 2>/dev/null
        popd
    end
end
