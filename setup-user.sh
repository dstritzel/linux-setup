#!/usr/bin/env zsh

# TODO: Consider Using .env file and generate values from there
GIT_USER=${GIT_USER:-"dstritzel"}
PYTHON_VERSION=${PYTHON_VERSION:-"3.13.3"}
NODE_VERSION=${NODE_VERSION:-"--lts"}
BREW_PACKAGES=${BREW_PACKAGES:-"pyenv pyenv-virtualenv nvm neovim gh"}
PIP_PACKAGES=${PIP_PACKAGES:-"neovim"}

# Output Configs/Env
echo "Github User: $GIT_USER"
echo "Python Version: $PYTHON_VERSION"

exit

# Install OMZ info
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp omz/zshrc $HOME/.zshrc
cp omz/zprofile $HOME/.zprofile
. $HOME/.zshrc

# Install Brew
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # TODO: Skip Kitty if there is no GUI
  ## Kitty Install - Ubuntu 24.04 Kitty is borked with nvim
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  ln -sf $HOME/.local/kitty.app/bin/kitty $HOME/.local/kitty.app/bin/kitten $HOME/.local/bin/
  cp $HOME/.local/kitty.app/share/applications/kitty.desktop $HOME/.local/share/applications/
  cp $HOME/.local/kitty.app/share/applications/kitty-open.desktop $HOME/.local/share/applications/
  sed -i "s|Icon=kitty|Icon=$(readlink -f $HOME)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" $HOME/.local/share/applications/kitty*.desktop
  sed -i "s|Exec=kitty|Exec=$(readlink -f $HOME)/.local/kitty.app/bin/kitty|g" $HOME/.local/share/applications/kitty*.desktop
  echo 'kitty.desktop' >$HOME/.config/xdg-terminals.list
  # Homebrew Install - We don't want to require root without good reason
  git checkout https://github.com/Homebrew/brew $HOME/.linuxbrew
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Homebrew Install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Install Kitty
  brew install kitty
else
  echo "Unknown OS = $OSTYPE"
fi

. $HOME/.zshrc

# User Setup nvim
rm -rf $HOME/.config/nvim
cp -r ./nvim $HOME/.config/

if [ ! -d $HOME/.ssh ]; then
  echo ".ssh does not exist"
  mkdir $HOME/.ssh
fi

cp ssh/ssh_config $HOME/.ssh/config

curl https://github.com/${GIT_USER}.keys | tee -a $HOME/.ssh/authorized_keys

# Brew Installs
brew install ${BREW_PACKAGES}

# NVM and Node
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
nvm install ${NODE_VERSION}
nvm use ${NODE_VERSION}

# Setup GIT
git config --global user.name "${GIT_USER}"
git config --global user.email "${GIT_USER}@users.noreply.github.com"
