#!/usr/bin/env fish

source (dirname (status filename))/../functions.fish; or exit

# Flatten Services menu
eupdate_run defaults write NSGlobalDomain NSServicesMinimumItemCountForContextSubmenu -int 32

# Hide hidden files on Finder
eupdate_run defaults write com.apple.finder AppleShowAllFiles -bool NO

# Disable .DS_Store on network drive
eupdate_run defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool YES

# Disable shadow on screen capture
eupdate_run defaults write com.apple.screencapture disable-shadow -bool YES

# Disable automatic launching Photos on connecting device
eupdate_run defaults write com.apple.imagecapture disableHotPlug -bool YES

# Disable creation default devices
eupdate_run defaults write com.apple.CoreSimulator EnableDefaultSetCreation -bool NO

# Disable automatic reopening of last project
eupdate_run defaults write com.apple.dt.Xcode ApplePersistenceIgnoreState -bool YES

# Disable prebuilts binaries
eupdate_run defaults write com.apple.dt.Xcode IDEPackageEnablePrebuilts -bool NO

exit $eupdate_exit_code
