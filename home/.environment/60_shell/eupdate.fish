#!/usr/bin/env fish

if type --query _evalcache_clear
    yes | _evalcache_clear && fish -c exit
else
    echo 'Skip _evalcache_clear'
end

if type --query fisher
    fisher update
else
    echo 'Skip fisher'
end

set -gx fish_update_completions_detach true
fish_update_completions
set --erase fish_update_completions_detach
