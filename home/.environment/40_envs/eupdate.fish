#!/usr/bin/env fish

if type --query swiftly
    swiftly update latest --assume-yes
else
    echo 'Skip swiftly'
end

if type --query rustup
    rustup update
else
    echo 'Skip rustup'
end

if type --query ghcup
    ghcup --no-verbose install ghc
    ghcup --no-verbose install cabal
    ghcup --no-verbose install hls
    ghcup --no-verbose install stack
else
    echo 'Skip ghcup'
end

if type --query fnm
    fnm install --lts
    npm install --global @aikidosec/safe-chain
else
    echo 'Skip fnm'
end

if type --query gh
    gh extension upgrade --all
else
    echo 'Skip gh'
end
