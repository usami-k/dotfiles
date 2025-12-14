#!/usr/bin/env fish

if type --query tlmgr
    tlmgr update --self --all
else
    echo 'Skip tlmgr'
end
