#!/usr/bin/env fish

set --global original_dir (pwd)
set --global current_dir (realpath (dirname (status filename)))

set -l steps \
    homebrew \
    backup \
    development-tools \
    ccpocket \
    texlive \
    shell \
    macos-settings \
    homeshick \
    repositories

cd $current_dir
for step in $steps
    set -l script ./$step/eupdate.fish
    if not test -x $script
        continue
    end

    echo '###' $script
    $script
end
cd $original_dir

echo '### Done'
date
