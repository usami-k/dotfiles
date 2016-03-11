#!/bin/zsh

echo '## homebrew'
brew upgrade --all && brew cleanup

echo '## homebrew cask'
brew cask install $(brew cask list) && brew cask cleanup

echo '## gem (bundler)'
bundle update && bundle clean --force

echo '## pip'
pip install --upgrade $(pip list --outdated | cut -d' ' -f1)
