#!/usr/bin/env fish

set -l mode $argv[1]
set -l host $__CFBundleIdentifier

if test "$mode" != full; or test -z "$host"; or not type --query brew
    exit 0
end

set -l casks (brew info --cask --installed --json=v2 | jq -r '.casks[] | .token as $t | .artifacts[] | .app? // empty | .[] | strings | "\($t)\t\(.)"')
or exit

for entry in $casks
    set -l token (string split -f1 \t $entry)
    set -l app (string split -f2 \t $entry)
    set -l plist /Applications/$app/Contents/Info.plist
    test -f $plist; or continue
    if test (plutil -extract CFBundleIdentifier raw -o - $plist 2>/dev/null) = $host
        echo "eupdate full を $app の中で実行している。$app は cask（$token）で管理しているので、homebrew ステップの upgrade で終了する。cask で管理していないターミナル（Terminal.app など）で実行する" >&2
        exit 1
    end
end
