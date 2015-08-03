function peco-ghq () {
    local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        CURSOR=$#BUFFER
    fi
    zle clear-screen
}
zle -N peco-ghq
bindkey '^]' peco-ghq
