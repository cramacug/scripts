#!/bin/bash

#TODO --> Replace cp --> mv
#VIM
cp ~/.vimrc /tmp/.vimrc_backup.$(date +"%Y-%m-%dT%T")
cp ./vim/vimrc  /tmp/.vimrc
mkdir ~/.vim/autoload/ -p
cp ./vim/vim-plug-init.vim ~/.vim/autoload/



