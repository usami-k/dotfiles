#!/bin/zsh

echo '## homebrew'
brew outdated

echo '## gem (bundler)'
bundle outdated --strict

echo '## pip'
pip3 list --outdated
