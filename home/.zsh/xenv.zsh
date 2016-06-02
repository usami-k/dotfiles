# swiftenv
which swiftenv >/dev/null && eval "$(swiftenv init --no-rehash -)"
# rbenv
which rbenv >/dev/null && eval "$(rbenv init --no-rehash -)"
# pyenv
which pyenv >/dev/null && eval "$(pyenv init --no-rehash -)"

# brew : 各種 *env ツールの PATH を除いて実行する
alias brew="PATH=${PATH/\/*\/*\/*env\/shims:/} brew"

