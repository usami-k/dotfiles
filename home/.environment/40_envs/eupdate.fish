#!/usr/bin/env fish

yes | _evalcache_clear && fish -c exit

fisher update
fish_update_completions

rustup update

gh extension upgrade --all

asdf plugin-update --all
asdf reshim
asdf install nodejs (asdf nodejs resolve lts --latest-available)
