#!/usr/bin/env fish

set -l exit_code 0

function backup_mackup
    command rm -rf ~/.backup/Mackup; or return
    mackup --force backup; or return

    rsync --archive --no-times --delete-delay --checksum ~/.backup/Mackup ~/backup/
end

if type --query shortcuts-export
    echo '--- shortcuts export'
    shortcuts-export
    or set exit_code 1
end

if type --query mackup
    echo '--- mackup backup'
    backup_mackup
    or set exit_code 1
else
    echo 'Skip mackup'
end

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
