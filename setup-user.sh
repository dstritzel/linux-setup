#!/bin/bash

# TODO: Consider Using .env file and generate values from there
GIT_USER="dstritzel"

# TODO: Double check zsh location then set
chsh -s /usr/bin/zsh

# User Setup nvim
rm -rf ~/.config/nvim
cp -r ./nvim ~/.config/

if [ ! -d ~/.ssh ]; then
  echo ".ssh does not exist"
  mkdir ~/.ssh
fi

cp ssh/config ~/.ssh/

# Only run if not system user
#if [[ $EUID -gt 999 ]]; then
curl https://github.com/${GIT_USER}.keys | tee -a ~/.ssh/authorized_keys
#fi

## Kitty Install - Ubuntu 24.04 Kitty is borked with nvim
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
echo 'kitty.desktop' >~/.config/xdg-terminals.list

# Pyenv
curl -fsSL https://pyenv.run | bash

# NVM and Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
nvm install --lts
nvm use --lts

# Setup GIT
git config --global user.name "${GIT_USER}"
git config --global user.email "${GIT_USER}@users.noreply.github.com"
