# fish user paths
fish_add_path -m $HOME/.local/bin

# graystatus
set GRAYSTATUS_COLOR_PROMPT brgreen
set GRAYSTATUS_SHOW_RIGHT_PROMPT 0

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
set --export LESS RSX

# jq : colorize
alias jq 'jq -C'

# EDITOR : CotEditor
if command -sq cot
    set --export EDITOR 'cot --wait'
end

# direnv
if command -sq direnv
    direnv hook fish | source
end

# rbenv
if command -sq rbenv
    rbenv init - | source
end

# pyenv
if command -sq pyenv
    pyenv init - | source
end

# asdf
if test -f /opt/homebrew/opt/asdf/libexec/asdf.fish
    source /opt/homebrew/opt/asdf/libexec/asdf.fish
end

# volta
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

########
