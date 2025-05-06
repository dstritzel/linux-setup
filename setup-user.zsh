#!/usr/bin/env zsh

# TODO: Consider Using .env file and generate values from there
GIT_USER=${GIT_USER:-"dstritzel"}
BREW_PACKAGES=${BREW_PACKAGES:-"pyenv pyenv-virtualenv nvm neovim gh neovim fzf tldr"}
PYTHON_VERSION=${PYTHON_VERSION:-"3.13.3"}
PIP_PACKAGES=${PIP_PACKAGES:-"neovim"}
NODE_PACKAGES=${NODE_PACKAGES:-"neovim"}
NODE_VERSION=${NODE_VERSION:-"--lts"}
INSTALL_KITTY=${INSTALL_KITTY:="true"}

# TODO, Grab packages from a package file
# I.E. brew_packages, python_packages(mybe justa requirements file), node_packages
# Output Configs/Env

echo "Github User: $GIT_USER"
echo "Python Version: $PYTHON_VERSION"
# TODO: List packages that will be installed

# Install OMZ info
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp omz/zshrc $HOME/.zshrc
cp omz/zprofile $HOME/.zprofile
. $HOME/.zshrc

# Install Brew
if [[ "$OSTYPE" == "linux-gnu"* ]]; then

  # Homebrew Install - We don't want to require root without good reason
  git checkout https://github.com/Homebrew/brew $HOME/.linuxbrew

  ## Kitty Install - Ubuntu 24.04 Kitty is borked with nvim
  if [[ "${INSTALL_KITTY}" == "true"]]; then
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    ln -sf $HOME/.local/kitty.app/bin/kitty $HOME/.local/kitty.app/bin/kitten $HOME/.local/bin/
    cp $HOME/.local/kitty.app/share/applications/kitty.desktop $HOME/.local/share/applications/
    cp $HOME/.local/kitty.app/share/applications/kitty-open.desktop $HOME/.local/share/applications/
    sed -i "s|Icon=kitty|Icon=$(readlink -f $HOME)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" $HOME/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f $HOME)/.local/kitty.app/bin/kitty|g" $HOME/.local/share/applications/kitty*.desktop
    echo 'kitty.desktop' >$HOME/.config/xdg-terminals.list
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Homebrew Install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Install Kitty (Might consider iTerm2 if compatability works)
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
omz reload

# Install Python and set it as our user default
pyenv install ${PYTHON_VERSION}
pyenv global ${PYTHON_VERSION}

# NVM and Node
nvm install ${NODE_VERSION}
nvm use ${NODE_VERSION}

# Setup GIT
git config --global user.name "${GIT_USER}"
git config --global user.email "${GIT_USER}@users.noreply.github.com"
