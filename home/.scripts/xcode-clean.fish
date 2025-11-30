#!/usr/bin/env fish

function trash_if_exists
    set -l target $argv[1]
    test -e $target; and trash -v $target
end

trash_if_exists ~/Library/Developer/Xcode/DerivedData
trash_if_exists ~/Library/Caches/com.apple.dt.Xcode
trash_if_exists ~/Library/Caches/org.swift.swiftpm
trash_if_exists ~/Library/org.swift.swiftpm

echo (pwd)
printf "このディレクトリでビルドキャッシュを削除しますか? (y/N): "
read -l answer

if test "$answer" = y
    find . -name .swiftpm -print0 | xargs -0 trash -v
    find . -name .build -print0 | xargs -0 trash -v
    find . -name Package.resolved -print0 | xargs -0 trash -v
    echo 完了しました
else
    echo キャンセルしました
end
