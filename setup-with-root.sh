#!/bin/bash

APTPKGS=$(grep -vE '^#.*$' -vE '^\s*$' aptpkgs | sed 's/\n/ /g')
# May need to split string later if there are too many packages

# Use unstable because a version >= 10.0 is required for neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update && apt install -y neovim

apt install -y $APTPKGS

# Need npm mermaid packages for mmdc
