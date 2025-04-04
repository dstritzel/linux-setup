#!/bin/bash

APTPKGS=$(grep -vE '^#.*$|^\s*$' aptpkgs | sed 's/\n/ /g')
# May need to split string later if there are too many packages

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# Use unstable because a version >= 10.0 is required for neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update && apt install -y neovim

sudo apt install -y ${APTPKGS}
sudo apt install python3-neovim
# Need npm mermaid packages for mmdc
sudo npm install -g @mermaid-js/mermaid-cli
sudo npm install -g neovim

tempfile=$(mktemp) &&
  curl -o "$tempfile" "https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo" &&
  sudo tic -x -o /etc/terminfo "$tempfile" &&
  rm "$tempfile"

# Cleanup

rm -f lazygit*
