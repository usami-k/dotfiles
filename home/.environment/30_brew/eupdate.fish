#!/usr/bin/env fish

if command --query brew
    brew bundle --global
end

# Update .Brewfile in dotfiles
if command --query brew
    brew bundle --global dump --force
    ~/.homesick/repos/homeshick/bin/homeshick --batch check
end

brew doctor
