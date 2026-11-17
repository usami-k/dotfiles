#!/usr/bin/env fish

source (dirname (status filename))/../functions.fish; or exit

if type --query _evalcache_clear
    yes | eupdate_run _evalcache_clear
    and eupdate_run fish -c exit
else
    echo 'Skip _evalcache_clear'
end

if type --query fisher
    eupdate_run fisher update
else
    echo 'Skip fisher'
end

set -gx fish_update_completions_detach true
eupdate_run fish_update_completions
set --erase fish_update_completions_detach

exit $eupdate_exit_code
