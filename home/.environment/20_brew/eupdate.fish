#!/usr/bin/env fish

if type --query brew
    brew bundle --global dump --force
    brew bundle --global
    brew doctor
else
    echo 'Skip brew'
end
