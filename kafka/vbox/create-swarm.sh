#!/usr/bin/env bash

worker_ip=${1:-192.168.0.51}
ip=$(ip -4 addr show enp0s8 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)

# Start Docker Swarm
docker swarm init --advertise-addr ${ip}

# Add worker nodes
USER=$(whoami)
add_cmd=$(docker swarm join-token worker | tail -n 2 | xargs)
ssh -i ~/.ssh/id_rsa -o "StrictHostKeyChecking=no" $USER@${worker_ip} << EOF
    eval $add_cmd
EOF