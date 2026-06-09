#!/usr/bin/env fish

if type --query brew
    echo "Homebrew, MAS, and cask updates may require sudo for app installers, launchctl services, and package uninstallers."
    sudo -v

    brew bundle --global dump --force

    # brew bundle は auto_updates true の cask（Chrome/Slack/IDE 系等）の更新をスキップするため補完。
    if test -d "/Library/Application Support/JAMF"
        yes Yes | script -q /dev/null brew upgrade --cask --greedy-auto-updates
    else
        brew upgrade --cask --greedy-auto-updates
    end

    brew bundle --global

    brew doctor
    # brew doctor は SOVERSION ミスマッチ等の dylib 参照切れを検知しないため補完。
    brew linkage --test
else
    echo 'Skip brew'
end
