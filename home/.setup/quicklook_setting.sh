#!/bin/sh
defaults write com.apple.finder QLEnableTextSelection -bool TRUE
killall Finder
