#!/usr/bin/env fish

set --global script_dir (realpath (dirname (status filename)))

if command --query mint
    mint bootstrap --mintfile $script_dir/Mintfile
end
