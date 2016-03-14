# EDITOR : CotEditor
export EDITOR="cot --wait"

# less : 1画面分のときは終了する、カラー表示する、行を折り返さない、画面をクリアしない
export LESS=FRSX
# less の履歴を保存しない
export LESSHISTFILE=-

# SwiftEnv
which swiftenv >/dev/null && eval "$(swiftenv init -)"

