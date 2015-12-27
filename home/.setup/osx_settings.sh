#!/bin/sh

# Disable .DS_Store on network drive
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool YES

# Enable text selection on QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool YES

# Disable Photos.app HotPlug
defaults write com.apple.ImageCapture disableHotPlug -bool YES

