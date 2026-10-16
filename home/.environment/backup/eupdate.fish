#!/usr/bin/env fish

set -l exit_code 0

function replace_open_codex_db_copy
    set -l live_db ~/.codex/memories_1.sqlite
    test -e $live_db-wal; or return 0

    echo '--- Codex SQLite snapshot'
    set -l work_dir (command mktemp -d); or return
    set -l snapshot $work_dir/memories_1.sqlite
    command /usr/bin/sqlite3 -init /dev/null -readonly -bail $live_db \
        '.timeout 5000' ".backup '$snapshot'"
    and command /usr/bin/sqlite3 -init /dev/null -bail $snapshot \
        'PRAGMA journal_mode=DELETE;' >/dev/null
    and command chmod 600 $snapshot
    and command mv $snapshot ~/.backup/Mackup/.codex/memories_1.sqlite
    set -l result $status
    command rm -rf $work_dir
    return $result
end

function backup_mackup
    command rm -rf ~/.backup/Mackup; or return
    mackup --force backup; or return

    set -l result 0
    if not replace_open_codex_db_copy
        echo 'warning: Codex SQLite snapshot failed, sending the plain copy' >&2
        set result 1
    end

    rsync --archive --no-times --delete-delay --checksum ~/.backup/Mackup ~/backup/
    or return
    return $result
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
