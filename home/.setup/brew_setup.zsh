#!/bin/zsh
brew tap $(cat brew_leaves | grep ".*/" | sed "s|\(.*\)/.*|\1|")
brew install $(cat brew_leaves | sed "s|.*/||" | sed "/^#/d")
