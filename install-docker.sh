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
apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 20.10.23 | head -1 | awk '{print $3}')
