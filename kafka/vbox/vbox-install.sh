#!/usr/bin/env bash
# This Script installs Docker and SSH onto Ubuntu. Also sets up networking

# Install OpenSSH and make it passwordless
user=ubuntu
sudo mkdir /home/${user}/.ssh
sudo chown ${user} /home/${user}/.ssh
sudo apt-get update
sudo apt-get -y install openssh-client openssh-server
sudo sed -i -e 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config
sudo service sshd restart

# rewrite network file for static IP
sudo cp /home/${user}/TwitterTail/kafka/vbox/01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml
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
sudo systemctl stop docker
sudo systemctl start docker

# add ubuntu to docker group
sudo usermod -aG docker ${user}
sudo chmod a+rwx /var/run/docker.sock
echo | su - ${user}