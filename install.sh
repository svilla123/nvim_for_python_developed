####There_script#######################
# there script, going to install ######
# a developed to nvim for python, #####
# for everthing used to debian ########
# #####################################

#!/bin/bash

set -e

sudo apt install -y software-properties-common
sudo add-apt-repository ppa:neovim-ppa/stable -y

sudo apt update

sudo apt install -y neovim

sudo apt install -y \
    nvim git curl unzip ripgrep fzf \
    python3 python3-pip python3-venv \
    nodejs npm \
    build-essential

echo "install neovim to python enviorement"

mkdir -p ~/.config 
rm -rf ~/.config/nvim/ 

cp -r ./nvim/ ~/.config/nvim

echo "install to pluggins"

AZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"

if [ ! -d "$LAZY_PATH" ]; then
  git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
fi

echo "update plugings"

nvim --headless "+Lazy! sync" +qa

echo "install complete, congratulations!!!"
echo "any question you contact me josesaulvillaperez@gmail.com"



