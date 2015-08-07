#!/bin/sh
brew update
brew install $(cat brew_leaves.txt | sed "/^#/d")
brew cask install $(cat brew_cask_list.txt | sed "/^#/d")
