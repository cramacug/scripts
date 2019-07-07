#!/bin/bash

FILE_RC="vimrc"
LOG_PATH="/tmp/update_$FILE_RC.log"

touch $LOG_PATH

TIME_STAMP=$(date +"%Y-%m-%dT%T")
echo "$TIME_STAMP" >> $LOG_PATH

echo "Update $FILE_RC file"

mv -v ~/.$FILE_RC "/tmp/$FILE_RC.backUp_$TIME_STAMP" >> $LOG_PATH
cp -v ./$FILE_RC ~/.$FILE_RC >> $LOG_PATH

# vim/autoload
AUTOLOAD=~/.vim/autoload

if [ -d "$AUTOLOAD" ]; then
  echo "$AUTOLOAD"
  cp ./vim/vim-plug-init.vim ~/.vim/autoload/
else
  mkdir ~/.vim/autoload/ -p
  cp ./vim/vim-plug-init.vim ~/.vim/autoload/
fi

echo "SUCCESS!"
