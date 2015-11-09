#!/bin/zsh
brew cask install $(cat cask_list | sed "/^#/d")
