#!/bin/bash

# 0. stop ubuntu pop-up
#source /etc/os-release

# if (( $(echo "${VERSION_ID} >= 22.04" |bc -l) )); then
#       sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
# fi

echo ">>>>>>>>>>>>>>>>>>> (input) the hostname:"
read sethostname


# 1. update package
sudo apt update
sudo apt upgrade -y
echo ">>>>>>>>>>>>>>>>>>> (completed) 1. update package"


# 2. install useful package
sudo apt install net-tools -y
sudo apt install unzip -y
sudo apt install tree -y
echo ">>>>>>>>>>>>>>>>>>> (completed) 2. install useful package"


# 3. set timezone
sudo timedatectl set-timezone Asia/Seoul
echo ">>>>>>>>>>>>>>>>>>> (completed) 3. set timezone"


# 4. set prohibit-password access
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
echo ">>>>>>>>>>>>>>>>>>> (completed) 4. set prohibit-password access"


# 5. change hostname
sudo hostnamectl set-hostname $sethostname
echo ">>>>>>>>>>>>>>>>>>> (completed) 5. change hostname - `hostname`"