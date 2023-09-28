#!/usr/bin/env fish

if command --query mackup
    echo '--- mackup backup'
    mackup --force backup
    mackup --force uninstall
end

echo '--- keychains backup'
rsync --archive --delete-during ~/Library/Keychains ~/backup/
