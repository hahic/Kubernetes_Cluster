#!/bin/bash

# 1. set  docker cgroup driver 
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

# 3. deactivate CRI of container.d runtime
sudo sed -i "/disabled_plugins/s/^/#/" /etc/containerd/config.toml
systemctl restart containerd
