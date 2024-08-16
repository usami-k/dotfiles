#!/usr/bin/env fish

# Flatten Services menu
defaults write NSGlobalDomain NSServicesMinimumItemCountForContextSubmenu -int 32

# Enable text selection on QuickLook
defaults write com.apple.finder QLEnableTextSelection -boolean true

# Disable .DS_Store on network drive
defaults write com.apple.desktopservices DSDontWriteNetworkStores -boolean true

# Disable shadow on screen capture
defaults write com.apple.screencapture disable-shadow -boolean true

# Disable automatic launching Photos on connecting device
defaults write com.apple.ImageCapture disableHotPlug -boolean true

# LaunchPad : Reset app positions
defaults write com.apple.dock ResetLaunchPad -boolean true
killall Dock
