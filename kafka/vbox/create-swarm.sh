#!/usr/bin/env bash

IP=$1

# Start Docker Swarm
docker swarm init --advertise-addr ${IP}

# Add worker nodes
