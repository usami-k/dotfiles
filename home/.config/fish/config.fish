# fix PATH value
set --local path_tmp
for p in $PATH
    set path_tmp $path_tmp (string replace '~' $HOME $p)
end
set --export PATH $path_tmp

# homebrew
set --export PATH $PATH /usr/local/sbin
# ruby
set --export PATH $PATH $HOME/.gem/ruby/2.6.0/bin
# local bin
set --export PATH $PATH $HOME/.local/bin

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
set --export LESS 'RSX'

# jq : colorize
alias jq 'jq -C'

# bc : mathlib
alias bc 'bc -l'

# brew : use default paths
alias brew 'env PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin brew'

# pipenv : always assign a virtual environment
set --export PIPENV_IGNORE_VIRTUALENVS 1

# EDITOR : CotEditor
if command -sq cot
    set --export EDITOR 'cot --wait'
end
