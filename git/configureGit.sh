#!/usr/bin/zsh

if [ $# -eq 0 ]; then
  echo  "Please, add email"
fi

#GIT
# Set vim as default editor
git config --global core.editor "vim"

# Set own configuration
git config --global user.name "Marc CG"
git config --global user.email "$1"
