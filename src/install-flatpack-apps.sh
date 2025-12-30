# Install Apps using Flatpak
# List of Flatpak apps to install
# - pgAdmin4
# - NotepadQQ
# - Discord
# - Brave Browser
# - Postman
# - Spotify
# - RedisInsight
# - MongoDB Compass
# - DBeaver Community Edition
# - OBS Studio
# - Flatseal (Manage flatpak apps permissions)
# - Gradia (Screenshot tool)
# - FileZilla
# - AnyDesk

#!/bin/bash

set -e

###################################################################################################################################

# Ensure the script is run without sudo privileges
if [ "$EUID" -eq 0 ]; then
  echo "❌ You cannot run this script with sudo privileges."
  exit 1
fi

###################################################################################################################################

# Define Apps origin from Flathub
FLATPAK_APPS=(
    org.pgadmin.pgadmin4
    com.notepadqq.Notepadqq
    com.discordapp.Discord
    com.brave.Browser
    com.getpostman.Postman
    com.spotify.Client
    com.redis.RedisInsight
    com.mongodb.Compass
    io.dbeaver.DBeaverCommunity
    com.obsproject.Studio
    com.github.tchx84.Flatseal
    be.alexandervanhee.gradia
    org.filezillaproject.Filezilla
    com.anydesk.Anydesk
)

###################################################################################################################################

# Add Flathub repository if not already added
echo "🔄 Updating flathub..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

###################################################################################################################################

# Install Flatpak Apps
echo "📦 Installing Flatpak apps..."
sudo flatpak install -y flathub "${FLATPAK_APPS[@]}"

###################################################################################################################################

echo "🚀 Done!"