#!/bin/zsh

echo '## homebrew'
brew update
brew upgrade --all && brew cleanup

echo '## homebrew cask'
brew cask install $(brew cask list) && brew cask cleanup

echo '## gem'
rbenv rehash
yes | gem update && gem cleanup

echo '## pip'
pyenv rehash
pip install --upgrade $(pip list --outdated | cut -d' ' -f1)
