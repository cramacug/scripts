#!/usr/bin/env bash

# Exit on fail. Circuit breaker.
set -o errexit

PI="pi"
MAC="mac"
KUBUNTU="kubuntu"
SERVER="server"

OS=$1
echo "Selected OS: $OS"

#############################################################################################
########## Linux Software
#############################################################################################
function install_Linux_Software() {
  sudo apt install -y vim htop
  sudo apt install -y zsh-theme-powerlevel9k zsh zsh-syntax-highlighting
  sudo apt-get install qemu-guest-agent
}

function amazon_corretto_11() {
  cd /tmp
  curl -LO https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.deb
  dpkg -i amazon-*.deb
}

function install_qemy_guest_agent() {
  # For Synology
  sudo apt-get install qemu-guest-agent
}

#############################################################################################
########## Linux Software
#############################################################################################

#############################################################################################
########## Oh my zsh
#############################################################################################
function install_OhMyZsh() {
  # Clear old installations
  local ZSH_RUNTIME_FOLDER="$HOME/.oh-my-zsh"
  if [ -d "$ZSH_RUNTIME_FOLDER" ]; then
    local TEMP_FOLDER="/tmp/$OS/oh_my_zsh/"
    echo "Move existing folder $ZSH_RUNTIME_FOLDER to $TEMP_FOLDER"
    mkdir -p "$TEMP_FOLDER"
    mv -v "$ZSH_RUNTIME_FOLDER" "$TEMP_FOLDER"
  fi

  # OH_MY_SH
  cd /tmp || exit
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  cd ~
}
#############################################################################################
########## Oh my zsh
#############################################################################################

#############################################################################################
########## Vim
#############################################################################################
function install_vim() {
  # Clear old installations
  local VIM_RUNTIME_FOLDER="$HOME/.vim_runtime"
  if [ -d "$VIM_RUNTIME_FOLDER" ]; then
    local TEMP_FOLDER="/tmp/$OS/vim_runtime/"
    echo "Move existing folder $VIM_RUNTIME_FOLDER to $TEMP_FOLDER"
    mkdir -p "$TEMP_FOLDER"
    mv -v "$VIM_RUNTIME_FOLDER" "$TEMP_FOLDER"
  fi

  git clone --depth=1 https://github.com/amix/vimrc.git "$VIM_RUNTIME_FOLDER"
  sh "$HOME/.vim_runtime/install_awesome_vimrc.sh"
  # Vim kotlin
  #  git clone https://github.com/udalov/kotlin-vim.git "$HOME/.vim/pack/plugins/start/kotlin-vim"

  # Vim-plug installer  -- https://github.com/junegunn/vim-plug
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  mkdir -p "$HOME/.vim/autoload"
  cp ./resources/vim/vim-plug-init.vim "$HOME/.vim/autoload"
}
#############################################################################################
########## Vim
#############################################################################################

#############################################################################################
########## docker
#############################################################################################
function install_docker() {
  # https://docs.docker.com/engine/install/ubuntu/

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  if [[ "$OS" == "$PI" || "$OS" == "$KUBUNTU" ]]; then
    echo "KUBUNTU"

    sudo apt-get remove docker docker-engine docker.io containerd runc || true
    sudo apt-get update
    sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common -y

    if [[ "$OS" == "$PI" ]]; then
      echo "PI"
      # arm64
      sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
    elif [[ "$OS" == "$KUBUNTU" ]]; then
      # x86_64/amd64
      echo "KUBUNTU"
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
    fi

    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo usermod -aG docker "$(whoami)"

  elif [[ "$OS" == "$MAC" ]]; then
    echo "WIP"
  else
    exit
  fi
}

#############################################################################################
########## docker
#############################################################################################


if [[ "$OS" == "$PI" ]]; then
  echo "PI"
  install_Linux_Software
  install_vim
  install_docker
  install_OhMyZsh
elif [[ "$OS" == "$KUBUNTU" ]]; then
  echo "KUBUNTU"
  install_Linux_Software
  install_vim
  install_docker
  install_OhMyZsh
elif [[ "$OS" == "$SERVER" ]]; then
  echo "SERVER"
  install_Linux_Software
  amazon_corretto_11
  install_vim
  install_docker
  install_OhMyZsh
  install_qemy_guest_agent
elif [[ "$OS" == "$MAC" ]]; then
  echo "MAC"
  # Previously should install brew
  # TODO
  exit
else
  echo "Please add valid SO"
  printf "Valid OS: %s, %s, %s, %s . \n" $PI, $MAC, $KUBUNTU, $SERVER
  exit
fi
