#!/usr/bin/env fish

set --global original_dir (pwd)
set --global current_dir (realpath (dirname (status filename)))

cd $current_dir
for script in ./*/eupdate.fish
    echo '###' $script
    eval $script
end
cd $original_dir

echo '### Done'
date
