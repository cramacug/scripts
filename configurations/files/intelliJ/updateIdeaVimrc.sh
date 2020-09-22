#!/bin/bash

FILE_RC="ideavimrc"
LOG_PATH="/tmp/update_$FILE_RC.log"

touch $LOG_PATH

TIME_STAMP=$(date +"%Y-%m-%dT%T")
echo "$TIME_STAMP" >> $LOG_PATH

echo "Update $FILE_RC file"

mv -v ~/.$FILE_RC "/tmp/$FILE_RC.backUp_$TIME_STAMP" >> $LOG_PATH
cp -v ./$FILE_RC ~/.$FILE_RC >> $LOG_PATH

echo "SUCCESS!"
