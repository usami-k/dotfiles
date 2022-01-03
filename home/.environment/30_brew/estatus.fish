#!/usr/bin/env fish

if command --query brew
    env HOMEBREW_NO_AUTO_UPDATE=yes brew bundle --global cleanup
end
