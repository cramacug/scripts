#!/usr/bin/env bash

# Exit on fail. Circuit breaker.
set -o errexit

KUBUNTU="kubuntu"
RASPI_K3s="raspi_k3s"

DATE=$(date "+%Y-%m-%dT%H_%M_%S")

RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

OS=$1
echo "Selected OS: $OS"

function soft_remove_old_folder() {
  # HINTS
  # FILE=/etc/resolv.conf
  # if [ -f "$FILE" ]; then
  #   echo "$FILE exists."
  # else
  #   echo "$FILE does not exist."
  # fi
  local path=$1

  if [ -d "${path}" ]; then
    delete_path="/tmp${path}_${DATE}"
    mkdir -p "${delete_path}"
    mv -v "${path}" "${delete_path}"
  fi
}

function install_basics() {
  printf "\n\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${GREEN} INSTALL ${NC} : ${BLUE} BASICS ${NC}\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "\n\n"
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y git htop curl jq qemu-guest-agent nfs-common containerd
}

function install_vim() {

  printf "\n\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${GREEN} INSTALL ${NC} : ${BLUE} VIM ${NC}\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  sudo apt install -y vim

  # Vim-plug installer  -- https://github.com/junegunn/vim-plug
  soft_remove_old_folder "${HOME}/.vim/autoload"
  mkdir -p "${HOME}/.vim/autoload"
  curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

function raspbian_k8s_packages() {
  sudo apt install -y raspi-utils
}

function set_git() {

  user="$(whoami)"
  email="dropade@gmail.com"
  echo "Configure git wit ${user} and ${email}\n"

  # Set own configuration
  git config --global user.name "${user}"
  git config --global user.email "${email}"

  git config --global core.editor "vim"
  git config --global fetch.prune true
  git config --global pull.rebase true
  git config --global push.autoSetupRemote true
}

function install_dotfiles() {

  soft_remove_old_folder "${HOME}/.dotfiles"

  cd "${HOME}"
  git clone https://github.com/cramacug/.dotfiles.git

  local raspbian_branch="k3s_raspbian"
  local kubuntu="kubuntu"

  if [[ "${OS}" == "${KUBUNTU}" ]]; then
    git checkout "${kubuntu}"
    sh "${HOME}/.dotfiles/"
  elif [[ "${OS}" == "${RASPI_K3s}" ]]; then
    git checkout "${raspbian_branch}"
    sh "${HOME}/.dotfiles/"
  else
    echo "Please add valid SO"
    printf "Valid OS: %s, %s . \n" $KUBUNTU, $RASPI_K3s
  fi
}

#############################################################################################
### Installation options
#############################################################################################

if [[ "${OS}" == "${KUBUNTU}" ]]; then
  printf "Execute command: ${BLUE}*************************************************************************************************** ${NC} \n"
  printf "Execute command: ${GREEN} INSTALL DEFAULT SETUP FOR: ${NC}  ${BLUE} $OS ${NC}\n"
  printf "Execute command: ${BLUE}*************************************************************************************************** ${NC} \n"
  install_basics
  install_vim
  install_dotfiles
  set_git
elif [[ "${OS}" == "${RASPI_K3s}" ]]; then
  printf "Execute command: ${BLUE}*************************************************************************************************** ${NC} \n"
  printf "Execute command: ${GREEN} INSTALL DEFAULT SETUP FOR: ${NC}  ${BLUE} $OS ${NC}\n"
  printf "Execute command: ${BLUE}*************************************************************************************************** ${NC} \n"
  install_basics
  install_vim
  raspbian_k8s_packages
  install_dotfiles
  set_git
else
  echo "Please add valid SO"
  printf "Valid OS: %s, %s . \n" $KUBUNTU, $RASPI_K3s
fi

printf "Execute command: ${BLUE}--------------------------------------------------------------------------------------------------- ${NC} \n"
printf "Execute command: ${GREEN} UPDATE ${NC} : ${BLUE} RC_FILES ${NC}\n"
printf "Execute command: ${BLUE}--------------------------------------------------------------------------------------------------- ${NC} \n"
printf "\n\n"

printf "${GREEN} INSTALLATION DONE! ${NC} \n"
printf "${RED} INSTALLATION DONE! ${NC} \n"
printf "${GREEN} INSTALLATION DONE! ${NC} \n"

