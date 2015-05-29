#!/bin/sh

# Disable App Nap
defaults write NSGlobalDomain NSAppSleepDisabled -bool yes

# Disable .DS_Store on network drive
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# Enable text selection on QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool yes
