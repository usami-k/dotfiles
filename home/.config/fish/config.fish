# homebrew
_evalcache brew shellenv fish

# fzf : exact match, custom layout
set --global --export FZF_DEFAULT_OPTS '--exact --inline-info --height=10'

# color theme
if test (defaults read -g AppleInterfaceStyle 2> /dev/null || echo 'Light') = 'Dark'
    fish_config theme choose 'ayu Dark'
else
    fish_config theme choose 'ayu Light'
end

# vivid : set ls colors
if test (defaults read -g AppleInterfaceStyle 2> /dev/null || echo 'Light') = 'Dark'
    set --global --export LS_COLORS (vivid generate one-dark)
else
    set --global --export LS_COLORS (vivid generate one-light)
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
set --global --export LESS RSX

# EDITOR : CotEditor
set --global --export EDITOR 'cot --wait'

# homeshick
source $HOME/.homesick/repos/homeshick/homeshick.fish

# fnm (node.js)
_evalcache fnm env --use-on-cd --version-file-strategy=recursive --shell fish

# rbenv (ruby)
_evalcache rbenv init - fish

# pyenv (python)
_evalcache pyenv init - fish

# ghcup (haskell)
fish_add_path --path --move $HOME/.ghcup/bin

# rustup / cargo (rust)
fish_add_path --path --move $HOME/.cargo/bin

# swiftly (swift)
source $HOME/.swiftly/env.fish
fish_add_path --path --move $SWIFTLY_BIN_DIR

# local
fish_add_path --path --move $HOME/.local/bin

# direnv
_evalcache direnv hook fish

# starship
_evalcache starship init fish --print-full-init

########

