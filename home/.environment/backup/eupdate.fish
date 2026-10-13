#!/usr/bin/env fish

set -l exit_code 0

function backup_mackup
    command rm -rf ~/.backup/Mackup; or return
    mackup --force backup; or return

    set -l codex_db $HOME/.codex/memories_1.sqlite
    if test -f $codex_db
        echo '--- Codex SQLite snapshot'
        set -l snapshot_dir $HOME/.backup/Mackup/.codex
        command mkdir -p $snapshot_dir; or return
        command /usr/bin/sqlite3 -noinit -readonly -bail $codex_db \
            '.timeout 5000' ".backup '$snapshot_dir/memories_1.sqlite'"; or return
        command /usr/bin/sqlite3 -noinit -bail $snapshot_dir/memories_1.sqlite \
            'PRAGMA journal_mode=DELETE;' >/dev/null; or return
    end

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
