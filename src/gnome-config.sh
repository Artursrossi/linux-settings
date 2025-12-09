# Gnome Configuration Script
# Icons Theme: Yaru
# Cursor Theme: Yaru
# Legacy Applications Theme: Yaru
# Sounds Theme: Yaru
# Gnome Extensions:
# - dash-to-dock

#!/bin/bash

set -e

###################################################################################################################################

# Install gnome-tweaks
echo "📦 Installing gnome-tweaks..."
sudo dnf install -y gnome-tweaks

###################################################################################################################################

# Install yaru-theme
echo "📦 Installing yaru-theme..."
sudo dnf install yaru-theme

###################################################################################################################################

# Install gnome-shell-extension-dash-to-dock
echo "📦 Installing gnome-shell-extension-dash-to-dock..."
sudo dnf install -y gnome-shell-extension-dash-to-dock

###################################################################################################################################

# Active dash-to-dock extension
# List extensions: "gnome-extensions list"
# Maybe its necessary to move extension to: "~/.local/share/gnome-shell/extensions/" (optional)
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

###################################################################################################################################

echo "🚀 Done!"