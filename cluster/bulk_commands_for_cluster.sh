#!/bin/bash

user="ubuntu"
pi00=192.168.1.100
pi01=192.168.1.101
pi02=192.168.1.102
pi03=192.168.1.103

upgrade="sudo apt update && sudo apt upgrade -yq"
install_mpi="sudo apt install mpich python3-mpi4py -qy"

clean="sudo apt autoremove -y"
shutdown="sudo shutdown -h now"

kubernetes="sudo apt-get update && sudo apt-get install -y apt-transport-https curl
                curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
                cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
                deb https://apt.kubernetes.io/ kubernetes-xenial main
                EOF
                sudo apt-get update
                sudo apt-get install -y kubelet kubeadm kubectl
                sudo apt-mark hold kubelet kubeadm kubectl"

command=$1

for pi in $pi00 $pi01 $pi02 $pi03
do
    echo "Execute command: $command on $pi"
    ssh "$user@$pi" $command
done
