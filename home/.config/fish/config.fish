# fish greeting
function fish_greeting
    fish --version
end

# homebrew
_evalcache /opt/homebrew/bin/brew shellenv fish

# color theme
fish_config theme choose 'Tomorrow Night Bright'

# vivid : set ls colors
set --global --export LS_COLORS (vivid generate one-dark)

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

# switch to jj workspace
function gg
    if test -d .jj
        jj workspace list -T 'name ++ "\n"' | fzf | read name
        cd (jj workspace root --name $name)
    else
        echo "Not a jj repository"
    end
end

# less : quit if one screen, colorize, chop long lines, no clearing screen
set --global --export LESS FRSX

# fzf : exact match, custom layout
set --global --export FZF_DEFAULT_OPTS '--exact --reverse --height=10'

# EDITOR : CotEditor
set --global --export EDITOR 'cot --wait'

# ghcup (haskell)
fish_add_path --path --move $HOME/.ghcup/bin

# rustup / cargo (rust)
fish_add_path --path --move $HOME/.cargo/bin

# swiftly (swift)
fish_add_path --path --move $SWIFTLY_BIN_DIR

# local
fish_add_path --path --move $HOME/.local/bin

# mise
_evalcache mise activate fish

# direnv
_evalcache direnv hook fish

# starship
_evalcache starship init fish --print-full-init

# safe-chain
source ~/.safe-chain/scripts/init-fish.fish # Safe-chain Fish initialization script
