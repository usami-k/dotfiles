#!/usr/bin/env fish

if command --query rustup
    rustup update
    cargo install-update --all
end
