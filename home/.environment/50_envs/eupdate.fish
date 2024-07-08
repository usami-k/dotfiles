#!/usr/bin/env fish

fish_update_completions

rustup update

asdf plugin-update --all
asdf reshim
