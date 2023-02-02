#!/bin/bash

source /etc/os-release



if (( $(echo "${VERSION_ID} >= 22.04" |bc -l) )); then
        echo "bigger than 22.04"
fi

