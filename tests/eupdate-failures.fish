#!/usr/bin/env fish

set -g environment (path resolve $argv[1])
set -g fixture (mktemp -d); or exit
set -g fish_bin (status fish-path)
set -g passed 0
function cleanup --on-event fish_exit
    command rm -rf -- "$fixture"
end

mkdir -p "$fixture/bin" "$fixture/home/backup" "$fixture/home/.homesick/repos/example" "$fixture/home/.homesick/repos/second"
set -gx HOME "$fixture/home"
# No user config or Homebrew path: every update command is a fixture executable.
set -gx PATH "$fixture/bin" /usr/bin /bin
set -gx TEST_CALLS "$fixture/calls"
printf '%s\n' "#!$fish_bin --no-config" \
    'set -l name (path basename (status filename))' \
    'set -l call (string join " " -- $name $argv)' \
    'echo $call >>"$TEST_CALLS"' \
    'if test "$call" = "$TEST_FAIL"; or test "$name" = "$TEST_FAIL"; exit $TEST_CODE; end' \
    'if test "$name" = git; echo old-tip; end' \
    'if test "$name" = ghq; echo example; end' \
    'exit 0' >"$fixture/bin/mock"
chmod +x "$fixture/bin/mock"
for name in brew jamf-sudo-autoyes gh cargo cargo-install-update ghcup curl sh npm uv shortcuts-export mackup rsync ghq gpg gpg-backup git homeshick defaults tlmgr fisher _evalcache_clear fish fish_update_completions
    ln -s mock "$fixture/bin/$name"
end

function run_case --argument-names step failed_command code expected_status
    set -gx TEST_FAIL "$failed_command"
    set -gx TEST_CODE $code
    printf '' >"$TEST_CALLS"
    "$fish_bin" --no-config --init-command 'function fish_update_completions; command fish_update_completions $argv; end; function fisher; command fisher $argv; end; function _evalcache_clear; command _evalcache_clear $argv; end' "$environment/$step/eupdate.fish" >"$fixture/output" 2>&1
    set -l actual $status
    if test $actual -ne $expected_status
        printf 'FAIL: %s / %s: expected %s, got %s\n' $step "$failed_command" $expected_status $actual >&2
        cat "$fixture/output" >&2
        exit 1
    end
    if test $expected_status -ne 0
        if not string match --quiet "*command failed (exit=$code): $failed_command*" <"$fixture/output"
            echo 'FAIL: missing command failure diagnostic' >&2
            cat "$fixture/output" >&2
            exit 1
        end
    end
    set -g passed (math $passed + 1)
end

function called --argument-names call
    contains -- "$call" (cat "$TEST_CALLS")
end
function require_call --argument-names call
    called "$call"; or begin
        echo "FAIL: expected command: $call" >&2
        exit 1
    end
end
function forbid_call --argument-names call
    if called "$call"
        echo "FAIL: unexpected command: $call" >&2
        exit 1
    end
end

for step in homebrew backup development-tools shell homeshick macos-settings texlive
    run_case $step '' 0 0
end
run_case homebrew 'jamf-sudo-autoyes brew upgrade --cask --greedy-auto-updates --no-ask' 7 1
require_call 'brew doctor'
run_case homebrew 'brew bundle --global dump --force --no-go' 3 1
forbid_call 'brew bundle --global install'
require_call 'brew upgrade --formula --no-ask'
for call in 'brew bundle --global install' 'brew upgrade --formula --no-ask' 'brew doctor'
    run_case homebrew "$call" 2 1
end
# Cover machines without the private wrapper as well.
command rm "$fixture/bin/jamf-sudo-autoyes"
run_case homebrew 'brew upgrade --cask --greedy-auto-updates --no-ask' 4 1
require_call 'brew doctor'
for code in 130 143
    run_case homebrew 'brew upgrade --cask --greedy-auto-updates --no-ask' $code $code
    forbid_call 'brew doctor'
end

run_case backup shortcuts-export 1 1
require_call 'mackup --force backup'
run_case backup 'mackup --force backup' 1 1
forbid_call "rsync --archive --no-times --delete-delay --checksum $HOME/.backup/Mackup $HOME/backup/"
require_call 'ghq list'
require_call 'gpg-backup check'
run_case backup "rsync --archive --no-times --delete-delay --checksum $HOME/.backup/Mackup $HOME/backup/" 1 1
require_call 'ghq list'
# A redirection failure happens before the wrapper function is entered.
command rm -r "$HOME/backup"
set -gx TEST_FAIL ''
"$fish_bin" --no-config "$environment/backup/eupdate.fish" >"$fixture/output" 2>&1
if test $status -ne 1
    echo 'FAIL: backup output redirection must fail the step' >&2
    exit 1
end
set -g passed (math $passed + 1)
mkdir -p "$HOME/backup"
for call in 'ghq list' 'gpg-backup check'
    run_case backup "$call" 1 1
end
run_case backup 'mackup --force backup' 130 130
forbid_call 'ghq list'

run_case development-tools 'gh extension upgrade --all' 1 1
require_call 'uv safe-chain-verify'
run_case development-tools 'cargo install-update --all' 1 1
for tool in ghc cabal hls stack
    run_case development-tools "ghcup install $tool --set" 1 1
    forbid_call 'ghcup gc --unset --tmpdirs'
end
require_call 'npm safe-chain-verify'
run_case development-tools curl 22 1
if string match --quiet 'sh *' (cat "$TEST_CALLS")
    echo 'FAIL: installer ran after failed download' >&2
    exit 1
end
run_case development-tools curl 130 130
set -l download (string split ' ' -- (string match 'curl *' (cat "$TEST_CALLS")))
if test -e "$download[4]"
    echo 'FAIL: interrupted download left its temporary installer' >&2
    exit 1
end
run_case development-tools sh 1 1
run_case development-tools 'npm safe-chain-verify' 1 1
require_call 'uv safe-chain-verify'
run_case development-tools 'uv safe-chain-verify' 1 1

run_case shell _evalcache_clear 1 1
forbid_call 'fish -c exit'
require_call 'fisher update'
run_case shell 'fisher update' 1 1
require_call fish_update_completions
run_case shell fish_update_completions 1 1
run_case shell _evalcache_clear 130 130
forbid_call 'fisher update'
run_case shell 'fisher update' 143 143
forbid_call fish_update_completions
for call in 'homeshick --batch pull example' 'homeshick --batch --force link' 'homeshick --batch check example'
    run_case homeshick "$call" 1 1
    require_call 'homeshick --batch check example'
    require_call 'homeshick --batch check second'
end
run_case macos-settings 'defaults write NSGlobalDomain NSServicesMinimumItemCountForContextSubmenu -int 32' 1 1
require_call 'defaults write com.apple.dt.Xcode IDEPackageEnablePrebuilts -bool NO'
run_case texlive 'tlmgr update --self --all' 1 1

# Drive a real changed step through the real driver, using only fixture commands.
mkdir -p "$fixture/environment/homebrew"
cp "$environment/eupdate.fish" "$environment/functions.fish" "$fixture/environment/"
begin
    printf '%s\n' "#!$fish_bin --no-config"
    tail -n +2 "$environment/homebrew/eupdate.fish"
end >"$fixture/environment/homebrew/eupdate.fish"
chmod +x "$fixture/environment/homebrew/eupdate.fish"
set -gx TEST_FAIL 'brew bundle --global dump --force --no-go'
set -gx TEST_CODE 1
"$fish_bin" --no-config "$fixture/environment/eupdate.fish" full >"$fixture/output" 2>&1
if test $status -ne 1; or not string match --quiet '*RUN END mode=full result=partial*failed_steps=homebrew' <"$fixture/output"
    echo 'FAIL: driver must retain the step failure' >&2
    cat "$fixture/output" >&2
    exit 1
end
set -g passed (math $passed + 1)
set -gx TEST_FAIL 'brew upgrade --cask --greedy-auto-updates --no-ask'
set -gx TEST_CODE 130
"$fish_bin" --no-config "$fixture/environment/eupdate.fish" full >"$fixture/output" 2>&1
if test $status -ne 130; or not string match --quiet '*RUN END mode=full result=interrupted*' <"$fixture/output"
    echo 'FAIL: driver must preserve interruption' >&2
    cat "$fixture/output" >&2
    exit 1
end
set -g passed (math $passed + 1)
echo "PASS: $passed failure-reporting scenarios"
