#!/usr/bin/env bash

# https://opensource.com/article/20/6/kubernetes-raspberry-pi

sudo cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/firmware/cmdline.txt


## 1
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

# Enable net.bridge.bridge-nf-call-iptables and -iptables6
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system



# container.io
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter


sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

# Using the systemd cgroup driver
# To use the systemd cgroup driver in /etc/containerd/config.toml with runc, set

# [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
#   ...
#   [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
#     SystemdCgroup = true

sudo systemctl restart containerd


# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Initialize cluster
# TOKEN=$(sudo kubeadm token generate)
kubeadm init --cri-socket /run/containerd/containerd.sock
kubeadm init --cri-socket /run/containerd/containerd.sock

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket /run/containerd/containerd.sock


sudo kubeadm join "$master":6443 --token "$token" \
    --pod-network-cidr=10.244.0.0/16 \
	--discovery-token-ca-cert-hash topSECRET \
     --cri-socket /run/containerd/containerd.sock



