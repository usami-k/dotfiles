# Check & Upgrade

## homebrew

* Check : `brew outdated`
* Upgrade : `brew upgrade --all && brew cleanup`

## homebrew cask

* Upgrade : `brew cask install $(brew cask list)`

## gem (bundler)

* Check : `bundle outdated`
* Upgrade : `bundle update && bundle clean --force`

## pip

* Check : `pip3 list --outdated`
* Upgrade : `pip3 install -U $(pip3 list --outdated | cut -d' ' -f 1)`

