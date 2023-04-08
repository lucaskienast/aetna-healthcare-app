#!/bin/bash

# Update System
sudo yum update -y

# Enable Password based Authentication
sudo sed -i '61 s/^.\{1\}//' /etc/ssh/sshd_config
sudo sed -i '62 s/^.\{1\}//' /etc/ssh/sshd_config
sudo sed -i '63 s/^/#/' /etc/ssh/sshd_config
sudo service sshd reload

# Install Docker
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo mkdir /opt/docker

# Setup user
sudo echo -e "Secret123\nSecret123" | sudo passwd ec2-user
sudo usermod -aG docker ec2-user
sudo usermod -aG wheel ec2-user
sudo sed -i '110 s/^.//' /etc/sudoers
