#!/usr/bin/env fish

~/.homesick/repos/homeshick/bin/homeshick --force pull
~/.homesick/repos/homeshick/bin/homeshick --force link

fisher update >/dev/null
