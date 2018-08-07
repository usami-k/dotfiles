# fish git prompt
set __fish_git_prompt_char_dirtystate '*'
set __fish_git_prompt_char_stagedstate '+'
set __fish_git_prompt_char_stashstate '$'
set __fish_git_prompt_char_untrackedfiles '?'

# fzf : exact match, custom layout
set --export FZF_DEFAULT_OPTS '--exact --inline-info --reverse --height=10'

# ls : show all, colorize, sort by version number
if command -sq gls
    alias ls 'gls -A --sort=version'
else
    alias ls 'ls -A'
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

# bc : mathlib
alias bc 'bc -l'

# homeshick
if status is-login
    source $HOME/.homesick/repos/homeshick/homeshick.fish
    source $HOME/.homesick/repos/homeshick/completions/homeshick.fish
end

# local bin
if status is-login
    set --export fish_user_paths $fish_user_paths $HOME/.local/bin
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

# java : use Android Studio
set --export JAVA_HOME '/Applications/Android Studio.app/Contents/jre/jdk/Contents/Home'
if status is-login
    set --export fish_user_paths $fish_user_paths $JAVA_HOME/bin
end

# EDITOR : CotEditor
if command -sq cot
    set --export EDITOR 'cot --wait'
end
