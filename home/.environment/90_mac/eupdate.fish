#!/usr/bin/env fish

# Flatten Services menu
defaults write NSGlobalDomain NSServicesMinimumItemCountForContextSubmenu -int 32

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Enable text selection on QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool true

# Disable .DS_Store on network drive
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable shadow on screen capture
defaults write com.apple.screencapture disable-shadow -bool true

# Disable automatic launching Photos on connecting device
defaults write com.apple.ImageCapture disableHotPlug -bool true

# Disable automatic reopening of last project
defaults write com.apple.dt.Xcode ApplePersistenceIgnoreState -bool YES

# LaunchPad : Reset app positions
defaults write com.apple.dock ResetLaunchPad -bool true
killall Dock
