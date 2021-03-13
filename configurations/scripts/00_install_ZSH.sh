#!/bin/sh

sudo apt install -y zsh-theme-powerlevel9k zsh zsh-syntax-highlighting

# Clear old zsh installations
if [ -d "$ZSH_RUNTIME_FOLDER" ]; then
  ZSH_RUNTIME_FOLDER="$HOME/.oh-my-zsh"
  TEMP_FOLDER="/tmp/OMZ/oh_my_zsh-$DATE/"
  echo "Move existing folder $ZSH_RUNTIME_FOLDER to $TEMP_FOLDER"
  mkdir -p "$TEMP_FOLDER"
  mv -v "$ZSH_RUNTIME_FOLDER" "$TEMP_FOLDER"
fi

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
