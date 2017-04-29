# ls : show all, colorize, sort by version number
if command -sq gls
    alias ls 'gls -A --color=auto --sort=version'
end
if command -sq gdircolors
    set -x LS_COLORS (string match -r '^.(.*).$' (gdircolors -c | string split ' ')[3])[2]
end

# cp : show files
alias cp 'cp -v'

# mv : show files
alias mv 'mv -v'

# rm : prompt once before removing, show files
if command -sq grm
    alias rm 'grm -I -v'
else
    alias rm 'rm -i -v'
end

# diff : unified format, colorize
if command -sq colordiff
    alias diff 'colordiff --unified'
else
    alias diff 'diff --unified'
end

# grep : colorize
set -x GREP_OPTIONS '--color=auto'

# less : colorize, chop long lines, no clearing screen
set -x LESS 'RSX'

# jq : colorize
alias jq 'jq -C'

# javascript
alias jsc '/System/Library/Frameworks/JavaScriptCore.framework/Resources/jsc'

# fzf
set -x FZF_LEGACY_KEYBINDINGS 0

# homeshick
if status is-login
    source $HOME/.homesick/repos/homeshick/homeshick.fish
    source $HOME/.homesick/repos/homeshick/completions/homeshick.fish
end

# go
set -x GOPATH $HOME/go
if status is-login
    set -x fish_user_paths $fish_user_paths $GOPATH/bin
end

# android
if status is-login
    set -x fish_user_paths $fish_user_paths $HOME/Library/Android/sdk/platform-tools $HOME/Library/Android/sdk/tools
end

# EDITOR : CotEditor
if command -sq cot
    set -x EDITOR 'cot --wait'
end
