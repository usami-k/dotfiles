#!/usr/bin/env fish

yes | _evalcache_clear && fish -c exit

fisher update
fish_update_completions

rustup update

asdf plugin-update --all
asdf reshim
