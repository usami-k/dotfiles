() {
    local zsh_completions_fpath=$(brew --prefix)/share/zsh-completions
    if [ -d $zsh_completions_fpath ]; then
        fpath=($zsh_completions_fpath $fpath)
    fi
}
