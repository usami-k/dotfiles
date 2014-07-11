#!/bin/sh

# tap external repository
brew tap caskroom/cask

# update homebrew
brew update

# install package
brew install $(cat brew_leaves.txt)

# cask install package
brew cask install $(cat brew_casklist.txt)

