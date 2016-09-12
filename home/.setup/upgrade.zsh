#!/bin/zsh

echo '## homebrew'
brew update
brew upgrade --all && brew cleanup
swiftenv rehash
rbenv rehash
pyenv rehash

echo '## homebrew cask'
brew cask install $(brew cask list) && brew cask cleanup

echo '## gem'
yes | gem update && gem cleanup

echo '## pip'
pip install --upgrade $(pip list --outdated | cut -d' ' -f1)
