#!/usr/bin/env bash
version=$1

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

printf "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
printf "Try to execute: \tmvn versions:set -DgenerateBackupPoms=false -DnewVersion=$version \n"
printf "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"


if [[ $version =~ .*SNAPSHOT$ ]]
then
    printf "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
    printf "\t${GREEN}$version ${NC} ends with -SNAPSHOT. The poms will be updated. \n"
    printf "\t${YELLOW}Updating poms to version $version\n${NC}"
    printf "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
    mvn versions:set -DgenerateBackupPoms=false -DnewVersion=$version
else
    printf "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
    printf "\t${RED}Version >> $version <<  does not end with -SNAPSHOT. Abort the update of the poms.\n${NC}"
    printf "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
fi

# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
