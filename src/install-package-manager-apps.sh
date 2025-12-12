# Install Apps via package manager
# Binaries list:
# - htop
# - gzip
# - net-tools
# - nmap
# - blueman (optional, test before)
# - vim
# Apps list:
# - Google Chrome
# - Visual Studio Code
# - Docker
# - Node Version Manager
# - VirtualBox

#!/bin/bash
set -e

###################################################################################################################################

# Simple DNF Packages
echo "📦 Installing standard repository packages..."
PACKAGES=(
    htop
    gzip
    net-tools
    nmap
    blueman
    vim
)

for PKG in "${PACKAGES[@]}"; do
    if rpm -q "$PKG" &>/dev/null; then
        echo "✔️  $PKG is already installed. Skipping."
    else
        echo "⬇️  Installing $PKG..."
        sudo dnf install -y "$PKG"
    fi
done

###################################################################################################################################

# Google Chrome
echo "⬇️  Installing google-chrome-stable..."
sudo dnf install -y google-chrome-stable

###################################################################################################################################

# Visual Studio Code
echo "⬇️  Installing visual studio code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install -y code

###################################################################################################################################

# Docker
echo "⬇️  Installing docker..."
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
echo "⬇️  Installing Node Version Manager (NVM)..."
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

# Reload zsh
source ~/.zshrc

# Load NodeJS from nvm
echo "🔌 Install latest LTS NodeJS version..."
nvm install 24

echo "🔌 Use latest LTS NodeJS version..."
nvm use 24

###################################################################################################################################

# VirtualBox
echo "⬇️  Installing VirtualBox and its dependencies..."

# 1. Enable RPM Fusion repositories
if ! dnf repolist | grep -q "rpmfusion-free-updates"; then
    echo "Enabling RPM Fusion free repository..."
    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
fi
if ! dnf repolist | grep -q "rpmfusion-nonfree-updates"; then
    echo "Enabling RPM Fusion nonfree repository..."
    sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

# 2. Update packages and install dependencies
echo "Updating packages and installing VirtualBox dependencies..."
sudo dnf update -y
sudo dnf install -y @development-tools
sudo dnf install -y kernel-devel kernel-headers dkms elfutils-libelf-devel zlib-devel

# 3. Install VirtualBox
echo "Installing VirtualBox..."
sudo dnf install -y VirtualBox

# 4. Rebuild kernel modules
echo "Rebuilding VirtualBox kernel modules..."
sudo /sbin/vboxconfig

# 5. Add user to vboxusers group
echo "Adding user $USER to vboxusers group..."
sudo usermod -a -G vboxusers $USER
echo "🚪 You may need to log out and log back in for VirtualBox group changes to take effect."

###################################################################################################################################

echo "🚀 Done!"