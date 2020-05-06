#!/usr/bin/env bash

IP1=${1:-192.168.0.50}
IP2=${2:-192.168.0.51}
if [[ ${IP2} =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    sudo sed -i -e 's/${IP1}/${IP2}/g' /etc/netplan/01-network-manager-all.yaml
    sudo netplan apply
else
    echo "Invalid IP"
fi