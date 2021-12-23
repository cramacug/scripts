#!/usr/bin/env bash

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tear-down

# node="node_name"
node_name=raspi8gb-00
node_name=$1
ssh_machine=""
# sudo kubectl drain $node_name --delete-local-data --force --ignore-daemonsets
sudo kubectl drain "$node_name" --delete-emptydir-data --force --ignore-daemonsets

# log in to node
# ssh  "$ssh_machine" "sudo kubeadm reset && sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X"

# return to kubelet
sudo kubectl delete node "$node_name"
# mv ~/.kube /tmp/kube_$(date +"%Y-%m-%dT%T")
