#!/usr/bin/env fish

if type --query swiftly
    swiftly update --assume-yes
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
else
    echo 'Skip fnm'
end

if type --query gh
    gh extension upgrade --all
else
    echo 'Skip gh'
end
