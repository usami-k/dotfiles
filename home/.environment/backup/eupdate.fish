#!/usr/bin/env fish

source (dirname (status filename))/../functions.fish; or exit

function backup_mackup
    eupdate_run /bin/rm -rf ~/.backup/Mackup; or return
    eupdate_run mackup --force backup; or return

    eupdate_run rsync --archive --no-times --delete-delay --checksum ~/.backup/Mackup ~/backup/
end

if type --query shortcuts-export
    echo '--- shortcuts export'
    eupdate_run shortcuts-export
end

if type --query mackup
    echo '--- mackup backup'
    backup_mackup
else
    echo 'Skip mackup'
end

if type --query ghq
    echo '--- ghq backup'
    eupdate_run ghq list >~/backup/ghq_list.txt
    or set -g eupdate_exit_code 1
else
    echo 'Skip ghq'
end

if type --query gpg
    echo '--- gpg backup check'
    eupdate_run gpg-backup check
else
    echo 'Skip gpg'
end

exit $eupdate_exit_code
