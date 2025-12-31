# Terminal Configuration Script
# Shell: Zsh
# Framework: Oh My Zsh [https://github.com/Artursrossi/fork-ohmyzsh]
# Plugins: zsh-autosuggestions, zsh-syntax-highlighting
# Theme: Dracula

#!/bin/bash

set -e

###################################################################################################################################

# Ensure the script is run without sudo privileges
if [ "$EUID" -eq 0 ]; then
  echo "❌ You cannot run this script with sudo privileges."
  exit 1
fi

###################################################################################################################################

# Install Shell
echo "📦 Installing zsh..."
sudo dnf install -y zsh

# Make default shell
chsh -s $(which zsh) || true

###################################################################################################################################

# Install Framework
echo "📦 Installing ohmyzsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Artursrossi/fork-ohmyzsh/master/tools/install.sh)" --keep-zshrc --unattended --install-dir="$TEMP_DIR" || true

###################################################################################################################################

# Install terminal theme
echo "📦 Installing zsh-dracula-theme..."
git clone https://github.com/Artursrossi/fork-zsh-dracula-theme.git "$TEMP_DIR/fork-zsh-dracula-theme"

echo "🔌 Setting up zsh-dracula-theme..."
mv "$TEMP_DIR/fork-zsh-dracula-theme/dracula.zsh-theme" ~/.oh-my-zsh/themes/dracula.zsh-theme
mv "$TEMP_DIR/fork-zsh-dracula-theme/lib" ~/.oh-my-zsh/themes/lib

###################################################################################################################################

# Install Plugins

## zsh-autosuggestions
echo "📦 Installing zsh-autosuggestions..."
git clone https://github.com/Artursrossi/fork-zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

## zsh-syntax-highlighting
echo "📦 Installing zsh-syntax-highlighting..."
git clone https://github.com/Artursrossi/fork-zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

###################################################################################################################################

# Apply Theme && Plugins configurations

echo "[MANUAL INTERVENTION] - Edit ~/.zshrc file."
echo "Replace the existing 'plugins=(...)' line with this:"
echo ""
echo "plugins=("
echo "  git"
echo "  zsh-autosuggestions"
echo "  zsh-syntax-highlighting"
echo ")"
echo ""
echo "Replace the existing 'ZSH_THEME' line with this:"
echo ""
echo "ZSH_THEME=\"dracula\""
echo ""
read -p "Have you saved the changes to ~/.zshrc? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Configuration incomplete. Please update ~/.zshrc to use the new plugins."
    exit 1
fi

###################################################################################################################################

echo "🚀 Done!"