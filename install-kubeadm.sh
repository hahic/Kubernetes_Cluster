#!/bin/bash

# 0-1. disable swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter


# 0-2. ipv4 forwading
# 필요한 sysctl 파라미터를 설정하면, 재부팅 후에도 값이 유지된다.
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf 
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# 재부팅하지 않고 sysctl 파라미터 적용하기
sudo sysctl --system


# # 0-3. init crio
# sudo kubeadm config images pull --cri-socket unix:///var/run/crio/crio.sock


# 1. install dependent packages
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl


# 2. add kubernetes apt repository
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


# 3. install kubelet, kubeadm, kubectl
sudo apt-get update
#sudo apt-get install -y kubeadm=1.26.0-00 kubelet=1.26.0-00 kubectl=1.26.0-00 
sudo apt-get install -y kubeadm kubelet kubectl
sudo apt-mark hold kubelet kubeadm kubectl


# 4. pull image crio.socket
sudo kubeadm config images pull --cri-socket unix:///var/run/crio/crio.sock