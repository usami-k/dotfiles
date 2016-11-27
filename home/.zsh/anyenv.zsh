[ -d $HOME/.anyenv ] && {
    path=($HOME/.anyenv/bin $path)
}

which anyenv >/dev/null && eval "$(anyenv init --no-rehash -)"
