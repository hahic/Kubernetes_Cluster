#!/bin/bash

# 1. test 01
# source /etc/os-release

# if (( $(echo "${VERSION_ID} >= 22.04" |bc -l) )); then
#         echo "bigger than 22.04"
# fi


# 2. test 02
sudo hostnamectl set-hostname $1
hostname