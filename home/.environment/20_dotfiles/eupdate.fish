#!/usr/bin/env fish

~/.homesick/repos/homeshick/bin/homeshick --batch pull
~/.homesick/repos/homeshick/bin/homeshick --batch --force link

fisher update
fish_update_completions

asdf plugin-update --all
