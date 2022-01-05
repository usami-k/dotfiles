#!/usr/bin/env fish

if command --query brew
    brew bundle --global dump --force
    brew bundle --global
end
