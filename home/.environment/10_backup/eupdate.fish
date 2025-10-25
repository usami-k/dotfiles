#!/usr/bin/env fish

if type --query mackup
    echo '--- mackup backup'
    mackup --force backup
else
    echo 'Skip mackup'
end

echo '--- keychains backup'
rsync --archive --delete-delay ~/Library/Keychains ~/backup/

if type --query ghq
    echo '--- ghq backup'
    ghq list > ~/backup/ghq_list.txt
else
    echo 'Skip ghq'
end

if test -d $HOME/git
    echo '--- local git repos backup'
    rsync --archive --delete-delay $HOME/git ~/backup/
else
    echo 'Skip local git repos (directory not found)'
end
