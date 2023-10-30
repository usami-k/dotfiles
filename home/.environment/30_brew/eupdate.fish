#!/usr/bin/env fish

if command --query brew
    brew bundle --global
end

# Update .Brewfile in dotfiles
if command --query brew
    brew bundle --global dump --tap --brew --cask --mas --force
    ~/.homesick/repos/homeshick/bin/homeshick --batch check
end

brew doctor
