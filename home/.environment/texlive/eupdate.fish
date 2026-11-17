#!/usr/bin/env fish

source (dirname (status filename))/../functions.fish; or exit

if type --query tlmgr
    eupdate_run tlmgr update --self --all
else
    echo 'Skip tlmgr'
end

exit $eupdate_exit_code
