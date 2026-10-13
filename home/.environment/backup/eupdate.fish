#!/usr/bin/env fish

set -l exit_code 0

if type --query mackup
    echo '--- mackup backup'
    command rm -rf ~/.backup/Mackup
    mackup --force backup
    and rsync --archive --no-times --delete-delay --checksum ~/.backup/Mackup ~/backup/
    or set exit_code 1
else
    echo 'Skip mackup'
end

echo '--- keychains backup'
rsync --archive --delete-delay ~/Library/Keychains ~/backup/
or set exit_code 1

if type --query ghq
    echo '--- ghq backup'
    ghq list >~/backup/ghq_list.txt
    or set exit_code 1
else
    echo 'Skip ghq'
end

if type --query gpg
    echo '--- gpg backup check'
    gpg-backup check
    or set exit_code 1
else
    echo 'Skip gpg'
end

exit $exit_code
