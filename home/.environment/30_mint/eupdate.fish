#!/usr/bin/env fish

set --global script_dir (realpath (dirname (status filename)))

if type --query mint
    mint bootstrap --mintfile $script_dir/Mintfile
else
    echo 'Skip mint'
end
