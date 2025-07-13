#!/usr/bin/env fish

if type --query ~/.homesick/repos/homeshick/bin/homeshick
    ~/.homesick/repos/homeshick/bin/homeshick --batch pull
    ~/.homesick/repos/homeshick/bin/homeshick --batch --force link
else
    echo 'Skip homeshick'
end
