#!/usr/bin/env bash

# Exit on fail. Circuit breaker.
set -o errexit

PI="pi"
MAC="mac"
KUBUNTU="kubuntu"
SERVER="server"
K8_MASTER="k8_master"
K8_NODE="k8_node"

DATE=$(date +"%Y-%m-%dT%T")
RESOURCE_DIRECTORY="../files"

OS=$1
echo "Selected OS: $OS"

########## Linux Software
#############################################################################################
function install_basics() {
  sudo apt install -y vim htop curl
  sudo apt install -y zsh-theme-powerlevel9k zsh zsh-syntax-highlighting jq
  sudo apt-get install qemu-guest-agent
  git config --global core.editor "vim"

  sudo apt install nfs-common
  update_htoprc
}
function update_fstab() {
  #WIP
  # With max size --> noatime,nodiratime,nodev,nosuid,mode=1777,defaults,size=2048M
  local FSTAB="/etc/fstab"
  echo "# tmp on RAM" >>"$FSTAB"
  echo "# Folder mounted on ram." >>"$FSTAB"
  echo "tmpfs  /tmp                    tmpfs   noatime,nodiratime,nodev,nosuid,mode=1777,defaults      0       0" >>"$FSTAB"
  echo "tmpfs  /var/tmp                tmpfs   noatime,nodiratime,nodev,nosuid,mode=1777,defaults      0       0" >>"$FSTAB"

  # Maybe we do not need to mount smb or nfs folder
  # TODO remove
  #echo "# NFS on DS918+" >>"$FSTAB"
  #echo "192.168.1.96:/volume1/Raspberry_Storage         /mnt/nfs/DS918          nfs     auto,nofail,noatime,nolock,intr,tcp,actimeo=1800        0       0" >>"$FSTAB"

}

function amazon_corretto_11() {
  cd /tmp
  curl -LO https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.deb
  dpkg -i amazon-*.deb
}

#############################################################################################
########## Linux Software

########## Oh my zsh
#############################################################################################
function install_OhMyZsh() {
  # Clear old installations
  local ZSH_RUNTIME_FOLDER="$HOME/.oh-my-zsh"
  if [ -d "$ZSH_RUNTIME_FOLDER" ]; then
    local TEMP_FOLDER="/tmp/$OS/oh_my_zsh-$DATE/"
    echo "Move existing folder $ZSH_RUNTIME_FOLDER to $TEMP_FOLDER"
    mkdir -p "$TEMP_FOLDER"
    mv -v "$ZSH_RUNTIME_FOLDER" "$TEMP_FOLDER"
  fi
  # Clear old installations
  local INSTALLATION_FONTS_FOLDER="/tmp/fonts"
  if [ -d "$INSTALLATION_FONTS_FOLDER" ]; then
    rm -rf "$INSTALLATION_FONTS_FOLDER"
  fi

  # OH_MY_SH
  local current_f
  current_f=$(pwd)

  cd /tmp || exit
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  cd "$current_f"

  # Install powerLine fonts
  git clone --depth=1 https://github.com/powerline/fonts.git "$INSTALLATION_FONTS_FOLDER"
  cd "$INSTALLATION_FONTS_FOLDER" && sh ./install.sh
  rm -rfv "$INSTALLATION_FONTS_FOLDER" && cd "$current_f"

  # Install powerlevel9k theme
  git clone https://github.com/bhilburn/powerlevel9k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel9k"

  # Install powerlevel10k theme
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  cd "$HOME/.oh-my-zsh/plugins"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
  update_zshrc
}
#############################################################################################
########## Oh my zsh

########## Vim
#############################################################################################
function install_vim() {

  sudo apt install -y vim

  # Clear old installations
  local VIM_RUNTIME_FOLDER="$HOME/.vim_runtime"
  if [ -d "$VIM_RUNTIME_FOLDER" ]; then
    local TEMP_FOLDER="/tmp/$OS/vim_runtime-$DATE/"
    echo "Move existing folder $VIM_RUNTIME_FOLDER to $TEMP_FOLDER"
    mkdir -p "$TEMP_FOLDER"
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
#############################################################################################
########## Vim

# TODO Maybe it will remove for kubernetes 1.20
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
FILE=/etc/resolv.conf
if [ -f "$FILE" ]; then
  echo "$FILE exists."
else
  echo "$FILE does not exist."
fi

function update_zshrc() {
  #ZSH
  local CONFIG_RC_FILE="zshrc"
  local PATH_TEMP_BACK_UP_FILE="/tmp/$OS/$CONFIG_RC_FILE.$DATE"

  local PATH_FILE_UPDATED="$RESOURCE_DIRECTORY/zsh/$OS/$CONFIG_RC_FILE"
  local FILE_WITH_PATH_THAT_WILL_BE_UPDATED="$HOME/.$CONFIG_RC_FILE"

  if [ -f "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" ]; then
    echo "Back up file in: $PATH_PATH_TEMP_BACK_UP_FILE "
    mkdir -p "$PATH_TEMP_BACK_UP_FILE"
    mv -v "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" "$PATH_TEMP_BACK_UP_FILE"
  else
    cp -v "$PATH_FILE_UPDATED" "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED"
  fi

}

function update_vimrc() {
  local CONFIG_RC_FILE="vimrc"
  local PATH_TEMP_BACK_UP_FILE="/tmp/$OS/$CONFIG_RC_FILE.$DATE"

  local PATH_FILE_UPDATED="$RESOURCE_DIRECTORY/vim/$CONFIG_RC_FILE"
  local FILE_WITH_PATH_THAT_WILL_BE_UPDATED="$HOME/.$CONFIG_RC_FILE"

  if [ -f "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" ]; then
    echo "Back up file in: $PATH_PATH_TEMP_BACK_UP_FILE "
    mkdir -p "$PATH_TEMP_BACK_UP_FILE"
    mv -v "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" "$PATH_TEMP_BACK_UP_FILE"
  else
    cp -v "$PATH_FILE_UPDATED" "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED"
  fi

  # vim/autoload
  local PATH_VIM_AUTOLOAD="$HOME/.vim/autoload"
  local FILE_VIM_AUTOLAD="$RESOURCE_DIRECTORY/vim/vim-plug-init.vim"

  if [ -d "$PATH_VIM_AUTOLOAD" ]; then
    mkdir ~/.vim/autoload/ -p
  fi
  cp "$FILE_VIM_AUTOLAD" "$PATH_VIM_AUTOLOAD"
}

function update_htoprc() {
  local CONFIG_RC_FILE="htoprc"
  local PATH_TEMP_BACK_UP_FILE="/tmp/$OS/$CONFIG_RC_FILE.$DATE"

  local PATH_FILE_UPDATED="$RESOURCE_DIRECTORY/htop/$CONFIG_RC_FILE"
  local FILE_WITH_PATH_THAT_WILL_BE_UPDATED="$HOME/.config/htop/$CONFIG_RC_FILE"

  if [ -f "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" ]; then
    echo "Back up file in: $PATH_PATH_TEMP_BACK_UP_FILE "
    mkdir -p "$PATH_TEMP_BACK_UP_FILE"
    mv -v "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" "$PATH_TEMP_BACK_UP_FILE"
  else
    cp -v "$PATH_FILE_UPDATED" "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED"
  fi
}
#############################################################################################
### Installation options
#############################################################################################

if [[ "$OS" == "$KUBUNTU" ]]; then
  echo "$OS"
  install_basics
  update_fstab
  install_vim
  install_docker
  install_OhMyZsh
  install_ohMyZsh_powerlevel9k_theme
  install_ZshSyntaxHighlightingPlugin
elif [[ "$OS" == "$SERVER" ]]; then
  echo "$OS"
  install_basics
  update_fstab
  install_vim
  amazon_corretto_11
  install_docker
  install_OhMyZsh
  install_ohMyZsh_powerlevel9k_theme
  install_ZshSyntaxHighlightingPlugin
elif [[ "$OS" == "$K8_MASTER" ]]; then
  echo "$OS"
  install_basics
  update_fstab
  install_vim
  install_OhMyZsh
  #  install_docker
  #  container d
  install_ohMyZsh_powerlevel9k_theme
  install_ZshSyntaxHighlightingPlugin
elif [[ "$OS" == "$K8_NODE" ]]; then
  echo "$OS"
  install_basics
  update_fstab
  install_vim
  #  install_docker
  #  container d
elif [[ "$OS" == "$MAC" ]]; then
  echo "$OS"
  # Previously should install brew
  # TODO
else
  echo "Please add valid SO"
  printf "Valid OS: %s, %s, %s, %s . \n" $PI, $MAC, $KUBUNTU, $SERVER
fi
# String
if [[ "$OS" == "$PI" || "$OS" == "$MAC" || "$OS" == "$SERVER" || "$OS" == "$KUBUNTU" ]]; then
  echo "Selected OS: $OS"
  update_vimrc
  update_htoprc
  update_zshrc
else
  echo "Please add valid SO"
  printf "Valid OS: %s, %s, %s. \n" $PI $MAC $KUBUNTU
  exit
fi

echo "Installation of $OS done."
