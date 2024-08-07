#!/usr/bin/env fish

if command --query mackup
    echo '--- mackup backup'
    mackup --force backup
    mackup --force uninstall
    rsync --archive --delete-during ~/.backup/Mackup ~/backup/
end

echo '--- keychains backup'
rsync --archive --delete-during ~/Library/Keychains ~/backup/
