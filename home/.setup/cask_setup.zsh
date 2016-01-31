#!/bin/zsh
brew tap caskroom/cask
brew tap caskroom/fonts
brew cask install $(cat cask_list | sed "/^#/d")
