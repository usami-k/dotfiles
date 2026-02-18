# fish greeting
function fish_greeting
    LANG=ja_JP date
end

# homebrew
_evalcache /opt/homebrew/bin/brew shellenv fish

# fzf : exact match, custom layout
set --global --export FZF_DEFAULT_OPTS '--exact --reverse --height=10'

# color theme
if test (defaults read -g AppleInterfaceStyle 2> /dev/null || echo 'Light') = Dark
    fish_config theme choose 'Tomorrow Night Bright'
else
    fish_config theme choose Tomorrow
end

# vivid : set ls colors
if test (defaults read -g AppleInterfaceStyle 2> /dev/null || echo 'Light') = Dark
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

# diff using vscode (extension "moshfeu.compare-folders")
alias vsdiff 'COMPARE_FOLDERS=DIFF code --diff'

# less : quit if one screen, colorize, chop long lines, no clearing screen
set --global --export LESS FRSX

# EDITOR : CotEditor
set --global --export EDITOR 'cot --wait'

# rbenv (ruby)
_evalcache rbenv init - fish

# fnm (node.js)
_evalcache fnm env --use-on-cd --version-file-strategy=recursive --shell fish

# ghcup (haskell)
fish_add_path --path --move $HOME/.ghcup/bin

# rustup / cargo (rust)
fish_add_path --path --move $HOME/.cargo/bin

# swiftly (swift)
fish_add_path --path --move $SWIFTLY_BIN_DIR

# local
fish_add_path --path --move $HOME/.local/bin

# mise
if type --query ~/.local/bin/mise
    _evalcache ~/.local/bin/mise activate fish
end

# direnv
_evalcache direnv hook fish

# starship
_evalcache starship init fish --print-full-init

# safe-chain
source ~/.safe-chain/scripts/init-fish.fish # Safe-chain Fish initialization script

########
