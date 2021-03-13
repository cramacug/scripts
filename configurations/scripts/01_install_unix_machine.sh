#!/usr/bin/env bash

# Exit on fail. Circuit breaker.
set -o errexit

MAC="mac"
KUBUNTU="kubuntu"
K8_CLUSTER="k8_cluster"

DATE=$(date +"%Y-%m-%dT%T")
RESOURCE_DIRECTORY="../files"

RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

OS=$1
echo "Selected OS: $OS"

function install_basics() {
  printf "\n\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${GREEN} INSTALL ${NC} : ${BLUE} BASICS ${NC}\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "\n\n"
  sudo apt install -y vim htop curl
  sudo apt install -y jq
  sudo apt-get install qemu-guest-agent
  git config --global core.editor "vim"

  sudo apt install nfs-common
  update_htoprc
}

function amazon_corretto_11() {
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${GREEN} INSTALL ${NC} : ${BLUE} Amazon Corretto 11 ${NC}\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "\n\n"
  cd /tmp
  curl -LO https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.deb
  dpkg -i amazon-*.deb
}

function update_OhMyZsh() {
  printf "\n\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${GREEN} UPDATE ${NC} : ${BLUE} Oh My Zsh ${NC}\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "\n\n"

  # Clear old font installations
  local INSTALLATION_FONTS_FOLDER="/tmp/fonts"
  if [ -d "$INSTALLATION_FONTS_FOLDER" ]; then
    rm -rf "$INSTALLATION_FONTS_FOLDER"
  fi

  # Install powerLine fonts
  git clone --depth=1 https://github.com/powerline/fonts.git "$INSTALLATION_FONTS_FOLDER"
  cd "$INSTALLATION_FONTS_FOLDER" && sh ./install.sh
  rm -rfv "$INSTALLATION_FONTS_FOLDER" && cd "$current_f"

  # Install powerlevel9k theme
  git clone https://github.com/bhilburn/powerlevel9k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel9k"

  # Install powerlevel10k theme
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  # Install Syntax highlighting plugin
  mkdir -p "$HOME/.oh-my-zsh/plugins"
  cd "$HOME/.oh-my-zsh/plugins"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

  #ZSH
  local CONFIG_RC_FILE="zshrc"
  local PATH_TEMP_BACK_UP_FILE="/tmp/$OS/$CONFIG_RC_FILE.$DATE"

  local PATH_FILE_UPDATED="$RESOURCE_DIRECTORY/zsh/$OS/$CONFIG_RC_FILE"
  local FILE_WITH_PATH_THAT_WILL_BE_UPDATED="$HOME/.$CONFIG_RC_FILE"

  if [ -f "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" ]; then
    echo "Back up file in: $PATH_PATH_TEMP_BACK_UP_FILE "
    mkdir -p "$PATH_TEMP_BACK_UP_FILE"
    touch "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED"
    mv -v "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" "$PATH_TEMP_BACK_UP_FILE"
  fi
  cp -v "$PATH_FILE_UPDATED" "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED"
}

function install_vim() {

  printf "\n\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${GREEN} INSTALL ${NC} : ${BLUE} VIM ${NC}\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  sudo apt install -y vim

  # Clear old installations
  local VIM_RUNTIME_FOLDER="$HOME/.vim_runtime"
  if [ -d "$VIM_RUNTIME_FOLDER" ]; then
    local TEMP_FOLDER="/tmp/$OS/vim_runtime-$DATE/"
    echo "Move existing folder $VIM_RUNTIME_FOLDER to $TEMP_FOLDER"
    mkdir -p "$TEMP_FOLDER"
    touch "$VIM_RUNTIME_FOLDER"
    mv -v "$VIM_RUNTIME_FOLDER" "$TEMP_FOLDER"
  fi

  git clone --depth=1 https://github.com/amix/vimrc.git "$VIM_RUNTIME_FOLDER"
  sh "$HOME/.vim_runtime/install_awesome_vimrc.sh"

  # Vim-plug installer  -- https://github.com/junegunn/vim-plug
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  mkdir -p "$HOME/.vim/autoload"
  cp "$RESOURCE_DIRECTORY/vim/vim-plug-init.vim" "$HOME/.vim/autoload"
  update_vimrc
}

# TODO Maybe it will remove for kubernetes 1.20
function install_docker() {
  # https://docs.docker.com/engine/install/ubuntu/
  printf "\n\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${GREEN} INSTALL ${NC} : ${BLUE} DOCKER ${NC}\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "\n\n"
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  if [[ "$OS" == "$K8_CLUSTER" || "$OS" == "$KUBUNTU" ]]; then
    echo "KUBUNTU"

    sudo apt-get remove docker docker-engine docker.io containerd runc || true
    sudo apt-get update
    sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common -y

    if [[ "$OS" == "$K8_CLUSTER" ]]; then
      echo "$K8_CLUSTER"
      # arm64
      sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
    elif [[ "$OS" == "$KUBUNTU" ]]; then
      # x86_64/amd64
      echo "$KUBUNTU"
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


function update_vimrc() {
  printf "\n\n"
  printf "Execute command: ${BLUE}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${GREEN} UPDATE ${NC} : ${BLUE} VIMRC ${NC}\n"
  printf "Execute command: ${BLUE}--------------------------------------------------------------------------------------------------- ${NC} \n"

  local CONFIG_RC_FILE="vimrc"
  local PATH_TEMP_BACK_UP_FILE="/tmp/$OS/$CONFIG_RC_FILE.$DATE"

  local PATH_FILE_UPDATED="$RESOURCE_DIRECTORY/vim/$CONFIG_RC_FILE"
  local FILE_WITH_PATH_THAT_WILL_BE_UPDATED="$HOME/.$CONFIG_RC_FILE"

  if [ -f "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" ]; then
    echo "Back up file in: $PATH_PATH_TEMP_BACK_UP_FILE "
    mkdir -p "$PATH_TEMP_BACK_UP_FILE"
    touch "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED"
    mv -v "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" "$PATH_TEMP_BACK_UP_FILE"
  fi
  cp -v "$PATH_FILE_UPDATED" "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED"

  # vim/autoload
  local PATH_VIM_AUTOLOAD="$HOME/.vim/autoload"
  local FILE_VIM_AUTOLAD="$RESOURCE_DIRECTORY/vim/vim-plug-init.vim"

  if [ -d "$PATH_VIM_AUTOLOAD" ]; then
    mkdir ~/.vim/autoload/ -p
  fi
  cp "$FILE_VIM_AUTOLAD" "$PATH_VIM_AUTOLOAD"
}

function update_htoprc() {
  printf "\n\n"
  printf "Execute command: ${BLUE}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${GREEN} UPDATE ${NC} : ${BLUE} HTOP ${NC}\n"
  printf "Execute command: ${BLUE}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "\n\n"

  local CONFIG_RC_FILE="htoprc"
  local PATH_TEMP_BACK_UP_FILE="/tmp/$OS/$CONFIG_RC_FILE.$DATE"

  local PATH_FILE_UPDATED="$RESOURCE_DIRECTORY/htop/$CONFIG_RC_FILE"
  local FILE_WITH_PATH_THAT_WILL_BE_UPDATED="$HOME/.config/htop/$CONFIG_RC_FILE"

  if [ -f "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" ]; then
    echo "Back up file in: $PATH_PATH_TEMP_BACK_UP_FILE "
    mkdir -p "$PATH_TEMP_BACK_UP_FILE"
    touch "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED"
    mv -v "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" "$PATH_TEMP_BACK_UP_FILE"
  fi
  cp -v "$PATH_FILE_UPDATED" "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED"
}

#############################################################################################
### Installation options
#############################################################################################

if [[ "$OS" == "$KUBUNTU" ]]; then
  printf "Execute command: ${BLUE}*************************************************************************************************** ${NC} \n"
  printf "Execute command: ${GREEN} INSTALL DEFAULT SETUP FOR: ${NC}  ${BLUE} $OS ${NC}\n"
  printf "Execute command: ${BLUE}*************************************************************************************************** ${NC} \n"
  install_basics
  install_vim
  install_docker
  update_OhMyZsh
elif [[ "$OS" == "$K8_CLUSTER" ]]; then
  printf "Execute command: ${BLUE}*************************************************************************************************** ${NC} \n"
  printf "Execute command: ${GREEN} INSTALL DEFAULT SETUP FOR: ${NC}  ${BLUE} $OS ${NC}\n"
  printf "Execute command: ${BLUE}*************************************************************************************************** ${NC} \n"
  install_basics
  install_vim
  install_docker
  update_OhMyZsh
  #  container d  <--- TODO
elif [[ "$OS" == "$MAC" ]]; then
  echo "$OS"
  # Previously should install brew
  # TODO
else
  echo "Please add valid SO"
  printf "Valid OS: %s, %s, %s . \n" $MAC, $KUBUNTU, $K8_CLUSTER
fi

printf "Execute command: ${BLUE}--------------------------------------------------------------------------------------------------- ${NC} \n"
printf "Execute command: ${GREEN} UPDATE ${NC} : ${BLUE} RC_FILES ${NC}\n"
printf "Execute command: ${BLUE}--------------------------------------------------------------------------------------------------- ${NC} \n"
printf "\n\n"

printf "${GREEN} INSTALLATION DONE! ${NC} \n"

# HINTS
# FILE=/etc/resolv.conf
# if [ -f "$FILE" ]; then
#   echo "$FILE exists."
# else
#   echo "$FILE does not exist."
# fi
