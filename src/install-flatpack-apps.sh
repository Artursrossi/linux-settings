# Install Apps using Flatpak
# List of Flatpak apps to install
# - pgAdmin4
# - NotepadQQ
# - Discord
# - Brave Browser
# - Flameshot
# - Postman
# - Spotify
# - RedisInsight
# - MongoDB Compass
# - DBeaver Community Edition
# - OBS Studio
# - Flatseal (Manage flatpak apps permissions)

#!/bin/bash
set -e

###################################################################################################################################

# Define Apps origin from Flathub
APPS=(
    org.pgadmin.pgadmin4
    com.notepadqq.Notepadqq
    com.discordapp.Discord
    com.brave.Browser
    org.flameshot.Flameshot
    com.getpostman.Postman
    com.spotify.Client
    com.redis.RedisInsight
    com.mongodb.Compass
    io.dbeaver.DBeaverCommunity
    com.obsproject.Studio
    com.github.tchx84.Flatseal
)

###################################################################################################################################

# Add Flathub repository if not already added
echo "🔄 Updating flathub..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

###################################################################################################################################

# Install Apps
echo "📦 Installing Flatpak apps..."
for APP in "${APPS[@]}"; do
    if flatpak info "$APP" &>/dev/null; then
        echo "✔️ $APP already installed. Skipping."
    else
        echo "⬇️ Installing: $APP"
        sudo flatpak install -y flathub "$APP"
    fi
done

###################################################################################################################################

echo "🚀 Done!"