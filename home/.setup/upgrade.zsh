#!/bin/zsh

echo '## homebrew'
brew update
brew upgrade && brew cleanup

echo '## homebrew cask'
brew cu && brew cask cleanup

echo '## gem'
rbenv rehash
yes | gem update && gem cleanup

echo '## pip'
pyenv rehash
pip install --upgrade $(pip list --outdated | cut -d' ' -f1)

echo '## npm'
npm -g upgrade
