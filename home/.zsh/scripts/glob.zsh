# glob時に{}内で指定した文字を展開する
setopt brace_ccl
# globで#、~、^を有効にする
setopt extended_glob
# glob時にドット始まりのファイルも対象にする
setopt glob_dots
# glob時にファイル名を数値順にソートする
setopt numeric_glob_sort
# イコールの後でもファイル名展開を行う
setopt magic_equal_subst
# ファイル名展開でディレクトリ名の後ろにスラッシュをつける
setopt mark_dirs

