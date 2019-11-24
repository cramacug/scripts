#!/bin/bash

sudo apt update && apt upgrade -y
sudo apt install htop zsh vim zsh-theme-powerlevel9k

##################################################
## Docker
##################################################


sudo add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# sudo usermod -aG docker your-user
sudo usermod -aG docker ubuntu

##################################################
## Install software for wake on lan
##################################################
# https://www.cyberciti.biz/tips/linux-send-wake-on-lan-wol-magic-packets.html

sudo apt-get install etherwake

##################################################
## Disable Wifi
##################################################
# https://raspberrypi.stackexchange.com/questions/43720/disable-wifi-wlan0-on-pi-3
ip a
sudo apt install wireless-tools
sudo iwconfig wlan0 txpower off
# or on
sudo iwconfig wlan0 down
# or up
