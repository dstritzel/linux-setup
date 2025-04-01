#!/bin/bash

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
if [[ $EUID > 999 ]]; then
  curl https://github.com/dstritzel.keys | tee -a ~/.ssh/authroized_keys
fi
