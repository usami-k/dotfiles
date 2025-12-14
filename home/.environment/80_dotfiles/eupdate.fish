#!/usr/bin/env fish

if type --query homeshick
    homeshick --batch pull
    homeshick --batch --force link
else
    echo 'Skip homeshick'
end
