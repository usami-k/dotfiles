#!/usr/bin/env fish

if type --query mackup
    echo '--- mackup backup'
    mackup --force backup
    mackup --force uninstall
    rsync --archive --delete-during ~/.backup/Mackup ~/backup/
else
    echo 'Skip mackup'
end

echo '--- keychains backup'
rsync --archive --delete-during ~/Library/Keychains ~/backup/
