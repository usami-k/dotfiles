#!/usr/bin/env fish

fisher update
fish_update_completions

z --clean

rustup update

asdf plugin-update --all
asdf reshim
