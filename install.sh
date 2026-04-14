#!/bin/bash
set -e 

echo "########################################################"
echo "###  Neovim IDE Installer for Python & Debian        ###"
echo "########################################################"

echo "Updating system and installing base dependencies..."
sudo apt update
sudo apt install -y git curl unzip ripgrep fzf python3 python3-pip python3-venv nodejs npm build-essential

# --- NEOVIM INSTALLATION (Binary Method for Debian) ---
# Since Debian 12 doesn't support Ubuntu PPAs
echo "Downloading latest stable Neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
# Create a symbolic link so 'nvim' command works globally
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

echo "Installing Python support for Neovim..."
# Using --break-system-packages for Debian 12 compatibility
pip3 install --user pynvim --break-system-packages || pip3 install --user pynvim

# --- CONFIGURATION ---
echo "Setting up configuration files..."
mkdir -p ~/.config 
rm -rf ~/.config/nvim/ 

# Check if your local
if [ -d "./nvim" ]; then
    cp -r ./nvim/ ~/.config/nvim
    echo "Configuration folder copied successfully."
else
    echo "Warning: Local ./nvim folder not found. Creating a blank one."
    mkdir -p ~/.config/nvim
fi

# --- PLUGINS
echo "Installing Lazy.nvim plugin manager..."
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"

if [ ! -d "$LAZY_PATH" ]; then
  git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
fi

echo "Syncing plugins..."
# Fixed
nvim --headless "+Lazy! sync" +qa

echo "--------------------------------------------------"
echo "Installation complete, congratulations!!!"
echo "Any questions? Contact me: josesaulvillaperez@gmail.com"
echo "--------------------------------------------------"
