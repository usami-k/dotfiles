#!/usr/bin/env fish

if type --query gh
    gh extension upgrade --all
else
    echo 'Skip gh'
end

if type --query swiftly
    swiftly update latest --assume-yes
else
    echo 'Skip swiftly'
end

if type --query cargo-install-update
    cargo install-update --all
else
    echo 'Skip cargo-install-update'
end

if type --query ghcup
    ghcup --no-verbose install ghc --set
    ghcup --no-verbose install cabal --set
    ghcup --no-verbose install hls --set
    ghcup --no-verbose install stack --set
    ghcup gc --unset --tmpdirs
else
    echo 'Skip ghcup'
end

curl -fsSL https://github.com/AikidoSec/safe-chain/releases/latest/download/install-safe-chain.sh | sh
if type --query --no-function npm
    npm safe-chain-verify
end
if type --query --no-function uv
    uv safe-chain-verify
end
