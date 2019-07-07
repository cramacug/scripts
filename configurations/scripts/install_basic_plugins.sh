#!/usr/bin/env bash

# Exit on fail. Circuit breaker.
set -o errexit

PI="pi"
MAC="mac"
KUBUNTU="kubuntu"

OS=$1
echo "Selected OS: $OS"

function install_ohMyZsh_powerlevel9k_theme() {
  # Clear old installations
  local INSTALLATION_FONTS_FOLDER="/tmp/fonts"
  if [ -d "$INSTALLATION_FONTS_FOLDER" ]; then
    rm -rf "$INSTALLATION_FONTS_FOLDER"
  fi

  # Install powerLine fonts
  git clone --depth=1 https://github.com/powerline/fonts.git "$INSTALLATION_FONTS_FOLDER"
  cd "$INSTALLATION_FONTS_FOLDER" && sh ./install.sh
  rm -rfv "$INSTALLATION_FONTS_FOLDER" && cd "$HOME"

  # Install powerlevel9k theme
  git clone https://github.com/bhilburn/powerlevel9k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel9k"
}

function install_ZshSyntaxHighlightingPlugin() {
  cd "$HOME/.oh-my-zsh/plugins"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

  # This plugin will be added in the zsh file

  #  echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "${ZDOTDIR:-$HOME}/zshrc"
  #  source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}

# String
if [[ "$OS" == "$PI" ]]; then
  echo "PI"
  install_ohMyZsh_powerlevel9k_theme
  install_ZshSyntaxHighlightingPlugin
elif [[ "$OS" == "$KUBUNTU" ]]; then
  echo "KUBUNTU"
  install_ohMyZsh_powerlevel9k_theme
  install_ZshSyntaxHighlightingPlugin
elif [[ "$OS" == "$MAC" ]]; then
  echo "MAC"
  # Previously should install brew
  # TODO
  exit
else
  echo "Please add valid SO"
  printf "Valid OS: %s, %s, %s . \n" $PI, $MAC, $KUBUNTU
  exit
fi
