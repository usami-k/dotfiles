function g -d 'Change directory to select from ghq list'
    if not command -sq ghq
        echo 'Error: cd_ghq needs ghq command.'
    end
    if not command -sq fzf
        echo 'Error: cd_ghq needs fzf command.'
    end
    ghq list --full-path | fzf --query (commandline) | read selected
    test -n "$selected" ; and cd "$selected"
    commandline -f repaint
end
