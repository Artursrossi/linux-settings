# Gnome Configuration Script
# Icons Theme: Yaru
# Cursor Theme: Yaru
# Legacy Applications Theme: Yaru
# Sounds Theme: Yaru
# Interface Text Font: Ubuntu Regular (12 px)
# Document Text Font: Ubuntu Regular (12 px)
# Monospace Text Font: Ubuntu Mono Regular (14 px)
# Gnome Extensions:
# - dash-to-dock

#!/bin/bash

set -e

###################################################################################################################################

# Ensure the script is run without sudo privileges
if [ "$EUID" -eq 0 ]; then
  echo "❌ You cannot run this script with sudo privileges."
  exit 1
fi

###################################################################################################################################

# Install gnome-tweaks
echo "📦 Installing gnome-tweaks..."
sudo dnf install -y gnome-tweaks

###################################################################################################################################

# Install yaru-theme
echo "📦 Installing yaru-theme..."
sudo dnf install -y yaru-theme

###################################################################################################################################

# Install gnome-shell-extension-dash-to-dock
echo "📦 Installing gnome-shell-extension-dash-to-dock..."
sudo dnf install -y gnome-shell-extension-dash-to-dock

# Move extension from /usr/share/gnome-shell/extensions/ to ~/.local/share/gnome-shell/extensions/
EXTENSION_SRC="/usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"
EXTENSION_DEST="$HOME/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"

if [ -d "$EXTENSION_SRC" ]; then
    echo "📂 Copying dash-to-dock extension to local directory..."
    mkdir -p "$(dirname "$EXTENSION_DEST")"  # Ensure the destination directory exists
    cp -r "$EXTENSION_SRC" "$EXTENSION_DEST"  # Copy the directory recursively
fi

###################################################################################################################################

# Activate dash-to-dock extension
echo "🔌 Activating dash-to-dock extension..."
gnome-extensions enable dash-to-dock@micxgx.gmail.com

###################################################################################################################################

# Set dark mode
echo "🔌 Setting dark mode..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Auto-hide the dock
echo "🔌 Auto-hide the dock (dash-to-dock extension)..."
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

# Disable panel mode (Dock with 100 screen width)
echo "🔌 Disabling panel mode (dash-to-dock extension)..."
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false

# Set dock icon size to 40
echo "🔌 Setting dock icon size to 40 (dash-to-dock extension)..."
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40

# Set dock position to bottom
echo "🔌 Setting dock position to bottom (dash-to-dock extension)..."
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'

# Remove trash from dock
echo "🔌 Removing trash from dock (dash-to-dock extension)..."
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false

# Enable multiple dots style for running indicators
echo "🔌 Setting multiple dots indicator for running apps (dash-to-dock extension)..."
gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-style 'DOTS'

###################################################################################################################################

# Path to the image you want to set as the background
BACKGROUND_IMAGE="$(pwd)/wallpaper.jpg"
FINAL_BACKGROUND_IMAGE="$HOME/Pictures/wallpaper.jpg"

# Copy image to Pictures directory
cp "$BACKGROUND_IMAGE" "$FINAL_BACKGROUND_IMAGE"

# Check if the image exists
if [ ! -f "$FINAL_BACKGROUND_IMAGE" ]; then
  echo "❌ Background image not found: $FINAL_BACKGROUND_IMAGE"
  exit 1
fi

# Set the background image
echo "🔌 Setting background image..."
gsettings set org.gnome.desktop.background picture-uri "file://$FINAL_BACKGROUND_IMAGE"

###################################################################################################################################

# Ubuntu fonts:
# https://fonts.google.com/specimen/Ubuntu
# https://fonts.google.com/specimen/Ubuntu+Mono
# https://fonts.google.com/share?selection.family=Ubuntu+Mono:ital,wght@0,400;0,700;1,400;1,700|Ubuntu:ital,wght@0,300;0,400;0,500;0,700;1,300;1,400;1,500;1,700
# Copy to /usr/share/fonts/
# sudo cp -r Ubuntu /usr/share/fonts/
# sudo cp -r Ubuntu_Mono /usr/share/fonts/

# Update font cache
# sudo fc-cache -f -v

###################################################################################################################################

echo "🚀 Done!"