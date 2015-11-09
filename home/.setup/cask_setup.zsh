#!/bin/zsh
#brew tap caskroom/cask caskroom/fonts
brew cask install $(cat cask_list | sed "/^#/d")
