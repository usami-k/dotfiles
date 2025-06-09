#!/usr/bin/env fish

swiftly update --assume-yes

rustup update

ghcup --no-verbose install ghc
ghcup --no-verbose install cabal
ghcup --no-verbose install hls
ghcup --no-verbose install stack

fnm install --lts
fnm default system

gh extension upgrade --all
