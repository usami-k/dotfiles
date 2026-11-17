#!/usr/bin/env fish

source (dirname (status filename))/../functions.fish; or exit

if type --query gh
    eupdate_run gh extension upgrade --all
else
    echo 'Skip gh'
end

if type --query cargo-install-update
    eupdate_run cargo install-update --all
else
    echo 'Skip cargo-install-update'
end

if type --query ghcup
    eupdate_run ghcup install ghc --set
    and eupdate_run ghcup install cabal --set
    and eupdate_run ghcup install hls --set
    and eupdate_run ghcup install stack --set
    and eupdate_run ghcup gc --unset --tmpdirs
else
    echo 'Skip ghcup'
end

# Download must succeed before executing the installer.
set -g installer (mktemp)
or begin
    echo 'eupdate: could not create safe-chain installer file' >&2
    exit 1
end
function cleanup_installer --on-event fish_exit
    command rm -f -- "$installer"
    exit $argv[1]
end
eupdate_run curl -fsSL -o "$installer" https://github.com/AikidoSec/safe-chain/releases/latest/download/install-safe-chain.sh
and eupdate_run sh "$installer"
eupdate_run command rm -f -- "$installer"
if type --query --no-function npm
    eupdate_run npm safe-chain-verify
end
if type --query --no-function uv
    eupdate_run uv safe-chain-verify
end

exit $eupdate_exit_code
