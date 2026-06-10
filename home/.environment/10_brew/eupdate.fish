#!/usr/bin/env fish

if type --query brew
    echo "Homebrew, MAS, and cask updates may require sudo for app installers, launchctl services, and package uninstallers."
    sudo -v

    # cask の更新を先に実施しておく。auto_updates true の cask の更新も行う。
    if test -d "/Library/Application Support/JAMF"
        yes Yes | script -q /dev/null brew upgrade --cask --greedy-auto-updates
    else
        brew upgrade --cask --greedy-auto-updates
    end

    brew bundle --global dump --force

    brew bundle --global install

    brew doctor
else
    echo 'Skip brew'
end
