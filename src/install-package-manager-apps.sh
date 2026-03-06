# Install Apps via package manager
# Binaries list:
# - htop
# - gzip
# - net-tools
# - vim
# - blueman
# - nmap
# - telnet
# Apps list:
# - Google Chrome
# - Visual Studio Code
# - Docker
# - Node Version Manager
# - Veracrypt
# - KDiskMark

#!/bin/bash

set -e

###################################################################################################################################

# Ensure the script is run without sudo privileges
if [ "$EUID" -eq 0 ]; then
  echo "❌ You cannot run this script with sudo privileges."
  exit 1
fi

###################################################################################################################################

# Define Packages to install
PACKAGES=(
    htop
    gzip
    net-tools
    vim
    blueman
    nmap
    telnet
)

###################################################################################################################################

# Install DNF Packages
echo "📦 Installing standard repository packages..."
sudo dnf install -y "${PACKAGES[@]}"

###################################################################################################################################

# Google Chrome
echo "📦  Installing google-chrome-stable..."
sudo dnf install -y google-chrome-stable

###################################################################################################################################

# Visual Studio Code
echo "📦  Installing visual studio code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update || true
sudo dnf install -y code

###################################################################################################################################

# Docker
echo "📦  Installing docker..."
sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable docker service
echo "🔌 Starting up docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group to run docker without sudo
echo "🔌 Adding current user to docker group..."
sudo usermod -aG docker $USER
echo "🚪 You may need to log out and log back in for Docker group changes to take effect."

###################################################################################################################################

# Node Version Manager (NVM)
echo "📦  Installing Node Version Manager (NVM)..."
if [ -d "$HOME/.nvm" ]; then
    echo "✔️  NVM is already installed. Skipping."
else
    curl -o- https://raw.githubusercontent.com/Artursrossi/fork-nvm/master/install.sh | bash
    echo "✅ NVM installed. Please restart your terminal to use it."
fi

# Manual intervention to add NVM to .zshrc
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
echo "[MANUAL INTERVENTION] - Edit ~/.zshrc file."
echo "Add these lines:"
echo ""
echo "export NVM_DIR=\"$HOME/.nvm\""
echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\""
echo "[ -s \"$NVM_DIR/bash_completion\" ] && \. \"$NVM_DIR/bash_completion\""
echo ""
read -p "Have you saved the changes to ~/.zshrc? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Configuration incomplete. Please update ~/.zshrc to use the new plugins."
    exit 1
fi

# Reload zsh
echo "🔄 Reloading zshrc config..."
source ~/.zshrc

# Load NodeJS from nvm
echo "🔌 Install latest LTS NodeJS version..."
nvm install 24

echo "🔌 Use latest LTS NodeJS version..."
nvm use 24

###################################################################################################################################

# Veracrypt
# Download RPM package on: https://veracrypt.io/en/Downloads.html
# sudo dnf install fuse fuse-libs
# sudo rpm -i veracrypt-*.rpm

###################################################################################################################################

# KDiskMark
echo "⬇️  Installing KDiskMark..."
sudo dnf install -y kdiskmark

###################################################################################################################################

echo "🚀 Done!"