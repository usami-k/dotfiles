#!/usr/bin/env fish

if type --query _evalcache_clear
    yes | _evalcache_clear && fish -c exit
else
    echo 'Skip _evalcache_clear'
end

if type --query fisher
    fisher update
    fish_update_completions
else
    echo 'Skip fisher'
end
