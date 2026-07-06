#!/usr/bin/env fish

if type --query brew
    # cask の更新を先に実施しておく。auto_updates true の cask の更新も行う。
    brew upgrade --cask --greedy-auto-updates --no-ask

    set -l codex_plugins /Applications/Codex.app/Contents/Resources/plugins
    if test -d $codex_plugins
        find $codex_plugins -type d -name 'Codex Computer Use.app' -prune 2>/dev/null | while read -l app
            if not xattr -lr $app 2>/dev/null | string match -q '*com.apple.quarantine*'
                continue
            end
            echo "Remove quarantine attributes from $app"
            xattr -dr com.apple.quarantine $app
        end
    end

    brew bundle --global dump --force

    brew bundle --global install

    brew doctor
else
    echo 'Skip brew'
end
