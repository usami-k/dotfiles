# カーソル位置で補完を行う（これをしないとカーソルが単語の後ろにあるとして補完される）
setopt complete_in_word
# 補完時にエイリアスを解釈する
setopt complete_aliases
# globの補完を有効にする
setopt glob_complete

# 補完情報を冗長表示する
zstyle ":completion:*" verbose yes
# 補完候補をキャッシュファイルに保存する
zstyle ":completion:*" use-cache yes
# 補完候補の重複を避ける
zstyle ":completion:*" remove-all-dups yes
# 補完候補をセクション別に表示する
zstyle ":completion:*" separate-sections yes
# 補完候補に色をつける
zstyle ":completion:*" list-colors ""
# 補完候補をグループ表示する
zstyle ":completion:*" group-name ""
# グループ名の表示方法を指定する
zstyle ":completion:*" format "%U%d%u"
# 補完候補をカーソルキーで選択できるようにする（候補が2つ以上ある場合）
zstyle ":completion:*" menu select=2
# 補完候補がないとき大文字小文字を変えて補完候補を探す
zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
# 今いるディレクトリを補完候補から外す
zstyle ':completion:*' ignore-parents parent pwd ..

