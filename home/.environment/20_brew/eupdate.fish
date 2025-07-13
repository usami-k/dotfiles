#!/usr/bin/env fish

if type --query brew
    brew bundle --global
end

# Update .Brewfile in dotfiles
if type --query brew
    brew bundle --global dump --tap --brew --cask --mas --force
    ~/.homesick/repos/homeshick/bin/homeshick --batch check
end

brew doctor
