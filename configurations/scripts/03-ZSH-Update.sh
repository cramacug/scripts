#!/usr/bin/env bash

DATE=$(date "+%Y-%m-%dT%H_%M_%S")
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

function soft_remove_old_folder() {
  local path=$1

  if [ -d "${path}" ]; then
    delete_path="/tmp${path}_${DATE}"
    mkdir -p "${delete_path}"
    mv -v "${path}" "${delete_path}"
  fi
}


function update_omz() {

  printf "\n\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${GREEN} UPDATE ${NC} : ${BLUE} Oh My Zsh ${NC}\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "\n\n"

  # Install powerLine fonts
  printf "Install Powerline fonts: ${YELLOW}------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  local INSTALLATION_FONTS_FOLDER="/tmp/fonts_folder"
  soft_remove_old_folder "${INSTALLATION_FONTS_FOLDER}"
  mkdir -p  "${INSTALLATION_FONTS_FOLDER}"

  git clone --depth=1 https://github.com/powerline/fonts.git "$INSTALLATION_FONTS_FOLDER"
  cd "$INSTALLATION_FONTS_FOLDER" && sh ./install.sh
  rm -rfv "$INSTALLATION_FONTS_FOLDER" && cd "$HOME"

  # Install powerlevel10k theme
  printf "Install powerlevel10k: ${YELLOW}--------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  local INSTALL_POWERLEVEL10K_THEME_FOLDER="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
  soft_remove_old_folder "${INSTALL_POWERLEVEL10K_THEME_FOLDER}"
  mkdir -p "${INSTALL_ZSH_SYNTAX_HIGHLIGHTING_THEME_FOLDER}"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${INSTALL_POWERLEVEL10K_THEME_FOLDER}"

  # Install zsh-syntax-highlighting plugin
  printf "Install zsh-syntax-highlighting plugin: ${YELLOW}---------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  local INSTALL_ZSH_SYNTAX_HIGHLIGHTING_THEME_FOLDER="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
  soft_remove_old_folder "${INSTALL_ZSH_SYNTAX_HIGHLIGHTING_THEME_FOLDER}"
  mkdir -p "${INSTALL_ZSH_SYNTAX_HIGHLIGHTING_THEME_FOLDER}"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${INSTALL_ZSH_SYNTAX_HIGHLIGHTING_THEME_FOLDER}"

  # Install zsh-autosuggestions plugin
  printf "Install zsh-autosuggestions plugin: ${YELLOW}-------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  local INSTALL_AUTOSUGGETESTIONS_FOLDER="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  soft_remove_old_folder "${INSTALL_AUTOSUGGETESTIONS_FOLDER}"
  mkdir -p "${INSTALL_AUTOSUGGETESTIONS_FOLDER}"
  git clone https://github.com/zsh-users/zsh-autosuggestions  "${INSTALL_AUTOSUGGETESTIONS_FOLDER}"

  printf "${GREEN} INSTALLATION DONE! ${NC} \n"
  printf "${GREEN} INSTALLATION DONE! ${NC} \n"
  printf "${GREEN} INSTALLATION DONE! ${NC} \n"
}

update_omz