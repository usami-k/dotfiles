#!/usr/bin/env fish

fisher update
fish_update_completions

yes | _evalcache_clear

rustup update

asdf plugin-update --all
asdf reshim
