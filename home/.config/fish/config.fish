# clean fish_user_paths
set --erase fish_user_paths

# homebrew
_evalcache brew shellenv
fish_add_path -m /opt/homebrew/bin

# fzf : exact match, custom layout
set --export FZF_DEFAULT_OPTS '--exact --inline-info --reverse --height=10'

# color theme
if test (defaults read -g AppleInterfaceStyle 2> /dev/null || echo 'Light') = 'Dark'
    fish_config theme choose 'ayu Dark'
else
    fish_config theme choose 'ayu Light'
end

# vivid : set ls colors
if command -sq vivid
    if test (defaults read -g AppleInterfaceStyle 2> /dev/null || echo 'Light') = 'Dark'
        set --export LS_COLORS (vivid generate one-dark)
    else
        set --export LS_COLORS (vivid generate one-light)
    end
end

# ls : use lsd command
abbr --add ls lsd

# cp : show files
abbr --add cp cp -v

# mv : show files
abbr --add mv mv -v

# rm : prompt once before removing, show files
abbr --add rm rm -Iv

# diff : unified format, colorize
abbr --add diff diff --color -u

# less : colorize, chop long lines, no clearing screen
set --export LESS RSX

# EDITOR : CotEditor
if command -sq cot
    set --export EDITOR 'cot --wait'
end

# homeshick
if test -d $HOME/.homesick/repos/homeshick
    source $HOME/.homesick/repos/homeshick/homeshick.fish
end

# direnv
_evalcache direnv hook fish

# asdf
if test -f /opt/homebrew/opt/asdf/libexec/asdf.fish
    alias realpath 'builtin realpath'
    source /opt/homebrew/opt/asdf/libexec/asdf.fish
end

# rbenv
_evalcache rbenv init - fish

# pyenv
_evalcache pyenv init - fish

# haskell
fish_add_path -m $HOME/.ghcup/bin

# rust
fish_add_path -m $HOME/.cargo/bin

# android
fish_add_path -m $HOME/Library/Android/sdk/tools
fish_add_path -m $HOME/Library/Android/sdk/platform-tools

# local
fish_add_path -m $HOME/.local/bin

# starship
_evalcache starship init fish --print-full-init

########

