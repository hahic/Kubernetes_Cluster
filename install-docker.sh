#!/bin/bash

# 1. install dependent packages
sudo apt-get update

sudo apt-get install -y \
ca-certificates \
curl \
gnupg \
lsb-release


# 2. add docker apt repositoriy
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# 3. install docker-ce
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io


# 4. set  docker cgroup driver 
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker


# 5. deactivate CRI of container.d runtime
sudo sed -i "/disabled_plugins/s/^/#/" /etc/containerd/config.toml
systemctl restart containerd
