#!/usr/bin/env bash

# Exit on fail. Circuit breaker.
set -o errexit

RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

function update_fstab() {
  #WIP
  # With max size --> noatime,nodiratime,nodev,nosuid,mode=1777,defaults,size=2048M
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "Execute command: ${GREEN} UPDATE ${NC} : ${BLUE} FSTAB ${NC}\n"
  printf "Execute command: ${YELLOW}--------------------------------------------------------------------------------------------------- ${NC} \n"
  printf "\n\n"
  local FSTAB="/etc/fstab"
  echo "# tmp on RAM" >>"$FSTAB"
  echo "# Folder mounted on ram." >>"$FSTAB"
  echo "tmpfs  /tmp                    tmpfs   noatime,nodiratime,nodev,nosuid,mode=1777,defaults      0       0" >>"$FSTAB"
  echo "tmpfs  /var/tmp                tmpfs   noatime,nodiratime,nodev,nosuid,mode=1777,defaults      0       0" >>"$FSTAB"
  printf "${GREEN} INSTALLATION DONE! ${NC} \n"
}

# run
update_fstab
