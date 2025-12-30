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

# Define Apps origin from Flathub
APPS=(
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

# Ensure the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script as root (e.g., using sudo)."
    exit 1
fi

###################################################################################################################################

# Add Flathub repository if not already added
echo "🔄 Updating flathub..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

###################################################################################################################################

# Install Flatpak Apps
echo "📦 Installing Flatpak apps..."
flatpak install -y flathub "${APPS[@]}"

###################################################################################################################################

echo "🚀 Done!"