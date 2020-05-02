#!/usr/bin/env bash

cd /srv
git clone ...

# Install OpenSSH and make it passwordless - Do I need this?
sudo apt-get update
sudo apt-get -y install openssh-client openssh-server
sudo sed -i -e 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config
sudo service sshd restart

# rewrite network file for static IP
sudo cp ${REPO}/01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml
sudo netplan apply

# Docker Install (https://docs.docker.com/engine/install/ubuntu/)
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get -y install docker-ce docker-ce-cli containerd.io

# add lubuntu to docker group
sudo usermod -aG docker $(whoami)
echo | su - $(whoami)