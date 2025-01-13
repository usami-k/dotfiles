# clean fish_user_paths
set --erase fish_user_paths

# homebrew
_evalcache brew shellenv
fish_add_path -a /opt/homebrew/bin

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
set --export HOMESHICK_DIR /opt/homebrew/opt/homeshick
source $HOMESHICK_DIR/homeshick.sh

# direnv
_evalcache direnv hook fish

# asdf
source /opt/homebrew/opt/asdf/libexec/asdf.fish
fish_add_path -m $HOME/.asdf/shims

# rbenv
_evalcache rbenv init - fish
fish_add_path -m $HOME/.rbenv/shims

# pyenv
_evalcache pyenv init - fish
fish_add_path -m $HOME/.pyenv/shims

# haskell
fish_add_path -m $HOME/.ghcup/bin

# rust
fish_add_path -m $HOME/.cargo/bin

# android
fish_add_path -a $HOME/Library/Android/sdk/tools
fish_add_path -a $HOME/Library/Android/sdk/platform-tools

# local
fish_add_path -m $HOME/.local/bin

# starship
_evalcache starship init fish --print-full-init

########

