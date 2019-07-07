#!/usr/bin/env bash

# Exit on fail. Circuit breaker.
set -o errexit

# With max size --> noatime,nodiratime,nodev,nosuid,mode=1777,defaults,size=2048M

touch /tmp/fstab

echo "# tmp on RAM" >>/tmp/fstab
echo "# Folder mounted on ram." >>/tmp/fstab
echo "tmpfs                                           /tmp                    tmpfs   noatime,nodiratime,nodev,nosuid,mode=1777,defaults      0       0" >>/tmp/fstab
echo "tmpfs                                           /var/tmp                tmpfs   noatime,nodiratime,nodev,nosuid,mode=1777,defaults      0       0" >>/tmp/fstab

echo "# NFS on DS918+" >>/tmp/fstab
echo "192.168.1.96:/volume1/Raspberry_Storage         /mnt/nfs/DS918          nfs     auto,nofail,noatime,nolock,intr,tcp,actimeo=1800        0       0" >>/tmp/fstab
