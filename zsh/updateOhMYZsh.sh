#!/bin/bash

FILE_RC="zshrc"
LOG_PATH="/tmp/update_$FILE_RC.log"
FILE_RC="zshrc"

touch $LOG_PATH

timeStamp=$(date +"%Y-%m-%dT%T")
echo "$timeStamp" >> $LOG_PATH

echo "Update $FILE_RC file"

mv -v ~/.$FILE_RC "/tmp/$FILE_RC.backUp_$timeStamp" >> $LOG_PATH
cp -v ./$FILE_RC ~/.$FILE_RC >> $LOG_PATH

echo "SUCCESS!"
