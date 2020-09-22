#!/bin/bash

PI="pi"
MAC="mac"
KUBUNTU="kubuntu"

printf "Update files. "

OS=$1
echo "Selected OS: $OS"

# String
if [[ "$OS" == "$PI" || "$OS" == "$MAC" || "$OS" == "$KUBUNTU" ]]; then
  echo "KUBUNTU"
else
  echo "Please add valid SO"
  printf "Valid OS: %s, %s, %s. \n" $PI $MAC $KUBUNTU
  exit
fi

echo "works"

