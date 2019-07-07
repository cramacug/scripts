#!/usr/bin/env bash

INSTALL_FOLDER="/opt/helm"
USER=$(whoami)
TMP_FILE="/tmp/helm.tar.gz"
URL=""

sudo mkdir "$INSTALL_FOLDER"
sudo chown "$USER":"$USER" -R "$INSTALL_FOLDER"

cd /tmp || exit

curl -L $URL -o "$TMP_FILE"
tar -zxvf -C "$INSTALL_FOLDER" "$TMP_FILE"

#TODO Review
echo "PATH=$PATH:/opt/helm/" >> ~/.zshrc

# Add help repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
