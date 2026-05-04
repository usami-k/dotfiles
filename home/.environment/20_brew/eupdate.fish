#!/usr/bin/env fish

if type --query brew
    brew bundle --global dump --force
    brew bundle --global
    # brew bundle は auto_updates true の cask（Chrome/Slack/IDE 系等）の更新をスキップするため補完。
    brew upgrade --cask --greedy-auto-updates
    brew doctor
    # brew doctor は SOVERSION ミスマッチ等の dylib 参照切れを検知しないため補完。
    brew linkage --test
else
    echo 'Skip brew'
end
