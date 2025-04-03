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
if [[ $EUID -gt 999 ]]; then
  curl https://github.com/${GIT_USER}.keys | tee -a ~/.ssh/authroized_keys
fi
