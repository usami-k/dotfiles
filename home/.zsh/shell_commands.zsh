# auto cd
setopt auto_cd

# ls : show all, colorize, sort by version number
which gls >/dev/null && alias ls="gls -A --color=auto --sort=version"
which gdircolors >/dev/null && eval $(gdircolors)

# cp : show files
alias cp="cp -v"

# mv : show files
alias mv="mv -v"

# rm : prompt once before removing, show files
which grm >/dev/null && alias rm="grm -I -v"

# diff : unified format, colorize
alias diff="diff --unified"
which colordiff >/dev/null && alias diff="colordiff --unified"

# rename : based on zmv
autoload -Uz zmv
alias rename="noglob zmv -W"

# EDITOR : CotEditor
export EDITOR="cot --wait"

# grep : colorize
export GREP_OPTIONS="--color=auto"

# less : colorize, chop long lines, no clearing screen
export LESS=RSX
