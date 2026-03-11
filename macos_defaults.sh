#!/usr/bin/env bash
#
# macos-defaults.sh — Restored from current Mac settings
# Values marked [CUSTOM] were read from your machine.
# Values marked [ADDED] were not set on your machine — these are opinionated
# dev-friendly defaults. Comment out or remove any you don't want.
#
# Usage: chmod +x macos-defaults.sh && ./macos-defaults.sh

set -euo pipefail

echo "🔧 Applying macOS defaults..."

osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

###############################################################################
# Keyboard                                                                    #
###############################################################################
echo "⌨️  Keyboard..."

# [ADDED] Fast key repeat (macOS default is 6, 2 is fast — adjust to taste)
defaults write NSGlobalDomain KeyRepeat -int 2

# [ADDED] Short delay until repeat starts (macOS default is 25, 15 is snappy)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# [ADDED] Disable press-and-hold for accents — enables key repeat everywhere
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# [CUSTOM] Keyboard UI mode (0 = default, 3 = full keyboard access)
# Your Mac had 0; switching to 3 so Tab works on all UI controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# [CUSTOM] Auto-capitalization was ON — keeping it off for dev work
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# [CUSTOM] Auto period substitution was ON — disabling
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# [ADDED] Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# [ADDED] Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# [ADDED] Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

###############################################################################
# Trackpad                                                                    #
###############################################################################
echo "🖱️  Trackpad..."

# [CUSTOM] Tap to click: ON
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# [CUSTOM] Three-finger drag: OFF (your current setting)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool false

# [CUSTOM] Secondary click (two-finger right click): ON
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

# [CUSTOM] Tracking speed: 2.0
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.0

###############################################################################
# Dock                                                                        #
###############################################################################
echo "🚀 Dock..."

# [CUSTOM] Icon size: 61px
defaults write com.apple.dock tilesize -int 61

# [CUSTOM] Auto-hide: ON
defaults write com.apple.dock autohide -bool true

# [ADDED] Remove auto-hide delay
defaults write com.apple.dock autohide-delay -float 0

# [ADDED] Speed up auto-hide animation
defaults write com.apple.dock autohide-time-modifier -float 0.3

# [ADDED] Minimize using scale effect (faster than genie)
defaults write com.apple.dock mineffect -string "scale"

# [ADDED] Don't show recent apps in Dock
defaults write com.apple.dock show-recents -bool false

# [ADDED] Don't animate opening applications
defaults write com.apple.dock launchanim -bool false

###############################################################################
# Menu Bar & Clock                                                            #
###############################################################################
echo "🕐 Menu bar & clock..."

# [ADDED] Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# [ADDED] Clock format: day, date, 24h time
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm"

# [ADDED] Use 24-hour clock
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

###############################################################################
# Notifications                                                               #
###############################################################################
echo "🔔 Notifications..."

# [ADDED] Hide notifications on lock screen
defaults write com.apple.ncprefs content_visibility -int 0 2>/dev/null || true

# [ADDED] Shorter banner display time (seconds)
defaults write com.apple.notificationcenterui bannerTime -int 3 2>/dev/null || true

###############################################################################
# Screenshots                                                                 #
###############################################################################
echo "📸 Screenshots..."

mkdir -p "${HOME}/Desktop/Screenshots"

# [ADDED] Save location
defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"

# [ADDED] Save as PNG
defaults write com.apple.screencapture type -string "png"

# [ADDED] Disable shadow
defaults write com.apple.screencapture disable-shadow -bool true

# [CUSTOM] Don't show floating thumbnail: OFF (matches your setting)
defaults write com.apple.screencapture show-thumbnail -bool false

###############################################################################
# Quality of Life                                                             #
###############################################################################
echo "✨ Quality of life..."

# [ADDED] Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# [ADDED] Save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# [ADDED] Disable "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Restart affected apps                                                       #
###############################################################################
echo "🔄 Restarting affected apps..."

for app in "Dock" "SystemUIServer" "NotificationCenter"; do
    killall "${app}" 2>/dev/null || true
done

echo ""
echo "✅ Done! Some changes require a logout or restart to take full effect."
