#!/usr/bin/env bash

# Exit on fail. Circuit breaker.
set -o errexit

PI="pi"
MAC="mac"
KUBUNTU="kubuntu"
SERVER="server"

printf "Update files. "

touch ~/.zshrc
touch ~/.vimrc
touch ~/.config/htop/htoprc

OS=$1

function update_zshrc() {
  #ZSH
  DATE=$(date +"%Y-%m-%dT%T")
  local CONFIG_RC_FILE="zshrc"
  local PATH_TEMP_BACK_UP_FILE="/tmp/$OS/$CONFIG_RC_FILE.$DATE"

  local PATH_FILE_UPDATED="./resources/zsh/$OS/$CONFIG_RC_FILE"
  local FILE_WITH_PATH_THAT_WILL_BE_UPDATED="$HOME/$CONFIG_RC_FILE"

  echo "Back up file in: $PATH_PATH_TEMP_BACK_UP_FILE "
  mkdir -p "$PATH_TEMP_BACK_UP_FILE"
  mv -v "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" "$PATH_TEMP_BACK_UP_FILE"

  cp -v "$PATH_FILE_UPDATED" "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED"
}

function update_vimrc() {
  DATE=$(date +"%Y-%m-%dT%T")
  local CONFIG_RC_FILE="vimrc"
  local PATH_TEMP_BACK_UP_FILE="/tmp/$OS/$CONFIG_RC_FILE.$DATE"

  local PATH_FILE_UPDATED="./resources/vim/$CONFIG_RC_FILE"
  local FILE_WITH_PATH_THAT_WILL_BE_UPDATED="$HOME/$CONFIG_RC_FILE"

  echo "Back up file in: $PATH_PATH_TEMP_BACK_UP_FILE "
  mkdir -p "$PATH_TEMP_BACK_UP_FILE"
  mv -v "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" "$PATH_TEMP_BACK_UP_FILE"

  cp -v "$PATH_FILE_UPDATED" "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED"

  # vim/autoload
  local PATH_VIM_AUTOLOAD="$HOME/.vim/autoload"
  local FILE_VIM_AUTOLAD="./resources/vim/vim-plug-init.vim"

  if [ -d "$PATH_VIM_AUTOLOAD" ]; then
    mkdir ~/.vim/autoload/ -p
  fi
  cp "$FILE_VIM_AUTOLAD" "$PATH_VIM_AUTOLOAD"
}

function update_htoprc() {
  DATE=$(date +"%Y-%m-%dT%T")
  local CONFIG_RC_FILE="htoprc"
  local PATH_TEMP_BACK_UP_FILE="/tmp/$OS/$CONFIG_RC_FILE.$DATE"

  local PATH_FILE_UPDATED="./resources/htop/$CONFIG_RC_FILE"
  local FILE_WITH_PATH_THAT_WILL_BE_UPDATED="$HOME/.config/htop/$CONFIG_RC_FILE"

  echo "Back up file in: $PATH_PATH_TEMP_BACK_UP_FILE "
  mkdir -p "$PATH_TEMP_BACK_UP_FILE"
  mv -v "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED" "$PATH_TEMP_BACK_UP_FILE"

  cp -v "$PATH_FILE_UPDATED" "$FILE_WITH_PATH_THAT_WILL_BE_UPDATED"
}



# String
if [[ "$OS" == "$PI" || "$OS" == "$MAC" || "$OS" == "$SERVER"|| "$OS" == "$KUBUNTU" ]]; then
  echo "Selected OS: $OS"
  update_vimrc
  update_htoprc
  update_zshrc
else
  echo "Please add valid SO"
  printf "Valid OS: %s, %s, %s. \n" $PI $MAC $KUBUNTU
  exit
fi
