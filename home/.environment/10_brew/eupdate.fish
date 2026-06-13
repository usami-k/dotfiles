#!/usr/bin/env fish

if type --query brew
    # cask の更新を先に実施しておく。auto_updates true の cask の更新も行う。
    brew upgrade --cask --greedy-auto-updates --no-ask

    brew bundle --global dump --force

    brew bundle --global install

    brew doctor
else
    echo 'Skip brew'
end
