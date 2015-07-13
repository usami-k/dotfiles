#!/bin/sh

# Disable .DS_Store on network drive
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# Enable text selection on QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool yes
