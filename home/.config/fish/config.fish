# fzf : exact match, custom layout
set --export FZF_DEFAULT_OPTS '--exact --inline-info --reverse --height=10'

# fisherman fzf : no use legacy keybindings
set --export FZF_LEGACY_KEYBINDINGS 0

# ls : show all, colorize, sort by version number
if command -sq gls
    alias ls 'gls -A --sort=version'
end

# Erase unused functions
if command -sq greadlink
    rm -f (greadlink -f (brew --prefix)/share/fish/functions/ll.fish)
    rm -f (greadlink -f (brew --prefix)/share/fish/functions/la.fish)
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

# less : colorize, chop long lines, no clearing screen
set --export LESS 'RSX'

# jq : colorize
alias jq 'jq -C'

# javascript
alias jsc '/System/Library/Frameworks/JavaScriptCore.framework/Resources/jsc'

# homeshick
if status is-login
    source $HOME/.homesick/repos/homeshick/homeshick.fish
    source $HOME/.homesick/repos/homeshick/completions/homeshick.fish
end

# go
set --export GOPATH $HOME/go
if status is-login
    set --export fish_user_paths $fish_user_paths $GOPATH/bin
end

# android
set --export ANDROID_HOME $HOME/Library/Android/sdk
if status is-login
    set --export fish_user_paths $fish_user_paths $ANDROID_HOME/{platform-tools,tools}
end

# brew : avoid to use pyenv
function brew
    set --local brew_paths $PATH
    set --local pyenv_index (contains --index (pyenv root)/shims $brew_paths)
    set --erase brew_paths[$pyenv_index]
    env PATH=(string join ':' $brew_paths) brew $argv
end

# EDITOR : CotEditor
if command -sq cot
    set --export EDITOR 'cot --wait'
end
