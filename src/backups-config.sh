#!/bin/bash

set -e

###################################################################################################################################

echo "📦  Installing snapper and btrfs-assistant..."
sudo dnf install snapper btrfs-assistant

###################################################################################################################################

# 2. Create the configuration for your root (/)
sudo snapper -c root create-config /

sudo snapper -c root set-config ALLOW_USERS=$USER SYNC_ACL=yes

###################################################################################################################################

# Enable the specific Fedora repository for grub-btrfs
sudo dnf copr enable kylegospo/grub-btrfs

# Install the package
sudo dnf install grub-btrfs

sudo nano /etc/default/grub-btrfs/config

echo "[MANUAL INTERVENTION] - Edit ~/.zshrc file."
echo "Replace the existing 'plugins=(...)' line with this:"
echo ""
echo "GRUB_BTRFS_MKCONFIG=/usr/sbin/grub2-mkconfig"
echo "GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2""
echo "GRUB_BTRFS_SCRIPT_CHECK=grub2-script-check"
echo ""
read -p "Have you saved the changes to ~/.zshrc? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Configuration incomplete. Please update ~/.zshrc to use the new plugins."
    exit 1
fi

# Initialize the Snapshot Menu
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

###################################################################################################################################

echo "🚀 Done!"