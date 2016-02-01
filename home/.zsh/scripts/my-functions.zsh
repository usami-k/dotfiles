() {
    local home_functions_fpath=$HOME/.zsh/functions
    if [ -d $home_functions_fpath ]; then
        fpath=($home_functions_fpath $fpath)
    fi
}
