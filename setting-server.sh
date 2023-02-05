#!/bin/bash

# 0. stop ubuntu pop-up
#source /etc/os-release

# if (( $(echo "${VERSION_ID} >= 22.04" |bc -l) )); then
# 	sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
# fi


# 1. update package
sudo apt update
sudo apt upgrade -y


# 2. install useful package
sudo apt install net-tools -y
sudo apt install unzip -y
sudo apt install tree -y


# 3. set timezone 
sudo timedatectl set-timezone Asia/Seoul


# 4. set prohibit-password access
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
sudo systemctl restart sshd


# 5. change hostname
sudo hostnamectl set-hostname $1
hostname