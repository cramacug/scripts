#!/usr/bin/zsh

# https://raspberrypi.stackexchange.com/questions/43720/disable-wifi-wlan0-on-pi-3
ip a
sudo apt install wireless-tools
sudo iwconfig wlan0 txpower off
# or on
sudo iwconfig wlan0 down
# or up
