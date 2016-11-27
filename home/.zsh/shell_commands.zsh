# ls : 隠しファイルも表示する、カラー表示する、番号でソートする
which gls >/dev/null && alias ls="gls -A --color=auto --sort=version"
which gdircolors >/dev/null && eval $(gdircolors)

# cp : 進捗を表示する
alias cp="cp -v"

# mv : 進捗を表示する
alias mv="mv -v"

# rm : 削除前に確認する、進捗を表示する
which grm >/dev/null && alias rm="grm -I -v"

# diff : 常にカラー表示する、Unified 形式にする
alias diff="diff --unified"
which colordiff >/dev/null && alias diff="colordiff --unified"

# .. : 上位ディレクトリへ cd する
alias ..="cd .."

# rename : zmv ベースのリネームコマンド
autoload -Uz zmv
alias rename="noglob zmv -W"

# EDITOR : CotEditor
export EDITOR="cot --wait"

# grep : カラー表示する
export GREP_OPTIONS="--color=auto"

# less : 1画面分のときは終了する、カラー表示する、行を折り返さない、画面をクリアしない
export LESS=FRSX
# less の履歴を保存しない
export LESSHISTFILE=-
