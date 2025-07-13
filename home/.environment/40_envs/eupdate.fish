#!/usr/bin/env fish

if command --query swiftly
    swiftly update --assume-yes
else
    echo 'Skip swiftly'
end

if command --query rustup
    rustup update
else
    echo 'Skip rustup'
end

if command --query ghcup
    ghcup --no-verbose install ghc
    ghcup --no-verbose install cabal
    ghcup --no-verbose install hls
    ghcup --no-verbose install stack
else
    echo 'Skip ghcup'
end

if command --query fnm
    fnm install --lts
else
    echo 'Skip fnm'
end

if command --query gh
    gh extension upgrade --all
else
    echo 'Skip gh'
end
