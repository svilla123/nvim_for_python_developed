#!/bin/bash
set -e 

echo "########################################################"
echo "###  Neovim IDE Installer for Python & Debian        ###"
echo "########################################################"

# 1. Dependencias de Sistema Debian
echo "Installing system dependencies..."
sudo apt-get update -qq
sudo apt-get install -y -qq git curl unzip ripgrep fzf build-essential \
    python3-venv nodejs npm software-properties-common > /dev/null

# 2. Instalación de Neovim (Binario oficial para evitar PPAs rotos en Debian)
echo "Install Neovim" 
if ! command -v nvim &> /dev/null; then
    echo "Fetching Neovim binary..."
    curl -sLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim-linux
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
fi

# 3. Despliegue de tu configuración
NVIM_DEST="$HOME/.config/nvim"
echo "Deploying configuration..."
mkdir -p "$HOME/.config"

if [ -d "$NVIM_DEST" ]; then
    rm -rf "${NVIM_DEST}.bak"
    mv "$NVIM_DEST" "${NVIM_DEST}.bak"
fi
# Asumimos que ejecutas el script desde la raíz de tu repo de Git
cp -r ./nvim "$HOME/.config/"

# 4. Instalación silenciosa de Plugins
echo "Bootstrapping plugins (Headless)..."
nvim --headless "+Lazy! sync" +qa

echo "Installation complete. Contact: josesaulvillaperez@gmail.com"

echo "--------------------------------------------------"
echo "Installation complete, congratulations!!!"
echo "Any questions? Contact me: josesaulvillaperez@gmail.com"
echo "--------------------------------------------------"
