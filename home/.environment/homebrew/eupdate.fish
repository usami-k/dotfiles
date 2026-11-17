#!/usr/bin/env fish

source (dirname (status filename))/../functions.fish; or exit

if type --query brew
    # cask の更新を先に実施しておく。auto_updates true の cask の更新も行う。
    if type --query jamf-sudo-autoyes
        eupdate_run jamf-sudo-autoyes brew upgrade --cask --greedy-auto-updates --no-ask
    else
        eupdate_run brew upgrade --cask --greedy-auto-updates --no-ask
    end

    eupdate_run brew bundle --global dump --force --no-go
    and eupdate_run brew bundle --global install

    eupdate_run brew upgrade --formula --no-ask

    eupdate_run brew doctor
else
    echo 'Skip brew'
end

exit $eupdate_exit_code
