# homebrew
_evalcache brew shellenv

# fzf : exact match, custom layout
set --export FZF_DEFAULT_OPTS '--exact --inline-info --height=10'

# color theme
if test (defaults read -g AppleInterfaceStyle 2> /dev/null || echo 'Light') = 'Dark'
    fish_config theme choose 'ayu Dark'
else
    fish_config theme choose 'ayu Light'
end

# vivid : set ls colors
if test (defaults read -g AppleInterfaceStyle 2> /dev/null || echo 'Light') = 'Dark'
    set --export LS_COLORS (vivid generate one-dark)
else
    set --export LS_COLORS (vivid generate one-light)
end

# ls : use lsd command
abbr --add ls lsd

# cp : show files
alias cp 'cp -v'

# mv : show files
alias mv 'mv -v'

# rm : prompt once before removing, show files
alias rm 'rm -Iv'

# diff : unified format, colorize
alias diff 'diff --color -u'

# less : colorize, chop long lines, no clearing screen
set --export LESS RSX

# EDITOR : CotEditor
set --export EDITOR 'cot --wait'

# homeshick
source $HOME/.homesick/repos/homeshick/homeshick.fish

# android
fish_add_path --global --move --path $HOME/Library/Android/sdk/tools
fish_add_path --global --move --path $HOME/Library/Android/sdk/platform-tools

# fnm
_evalcache fnm env --use-on-cd --shell fish

# rbenv
_evalcache rbenv init - fish

# pyenv
_evalcache pyenv init - fish

# haskell
fish_add_path --global --move --path $HOME/.ghcup/bin

# rust
fish_add_path --global --move --path $HOME/.cargo/bin

# local
fish_add_path --global --move --path $HOME/.local/bin

# direnv
_evalcache direnv hook fish

# starship
_evalcache starship init fish --print-full-init

########

