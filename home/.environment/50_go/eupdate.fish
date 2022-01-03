#!/usr/bin/env fish

if command --query go
    function env_installed
        env GHQ_ROOT=(go env GOPATH)/src ghq list
    end

    for repo in (env_installed)
        pushd (go env GOPATH)/src/$repo
        git config rerere.enabled true
        popd
    end
end
