#!/usr/bin/env bash

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tear-down

# node="node_name"
node_name=raspi8gb-00

sudo kubectl drain $node_name --delete-local-data --force --ignore-daemonsets
sudo kubeadm reset
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -X
sudo kubectl delete node $node_name
mv ~/.kube /tmp/kube_$(date +"%Y-%m-%dT%T")
