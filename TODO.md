# General
    
    - Accept docker installation
    - Try to do not ask chanse shell
    - retunr to dof files. I do not remember the step

# CLUSTER

    - Set name of the host: `$ sudo hostnamectl set-hostname newNameHere`
    - Install helm
    - https://opensource.com/article/20/6/kubernetes-raspberry-pi

``` sh
    echo Adding " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" to /boot/firmware/cmdline.txt

    sudo cp /boot/cmdline.txt /boot/firmware/cmdline.txt
    orig="$(head -n1 /boot/cmdline_backup.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
    echo $orig | sudo tee /boot/cmdline_backup.txt
```


``` sh
    sudo apt install cifs-utils -y
    sudo mkdir -p /mnt/Raspberry_Storage
    sudo chown -R ubuntu:ubuntu /mnt/Raspberry_Storage

# TMP filesystem    -- mounted in RAM
    tmpfs                                   /tmp                    tmpfs   noatime,nodiratime,nodev,nosuid,mode=1777,defaults,size=2048M          0   0
    tmpfs                                   /var/tmp                tmpfs   noatime,nodiratime,nodev,nosuid,mode=1777,defaults,size=2048M          0   0
```   

    
``` sh
# Append the cgroups and swap options to the kernel command line
# Note the space before "cgroup_enable=cpuset", to add a space after the last existing item on the line
sudo sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/firmware/cmdline.txt
```


