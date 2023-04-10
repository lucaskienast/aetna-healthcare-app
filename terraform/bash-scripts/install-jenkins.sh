#!/bin/bash

# Update System
sudo yum update -y

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo amazon-linux-extras install epel -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
jenkins --version

# Install Git
sudo yum install git -y
git --version

# Install Maven
sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz
sudo tar -xvzf apache-maven-3.8.8-bin.tar.gz
sudo mv apache-maven-3.8.8 /opt/
sudo echo "export M2_HOME=/opt/apache-maven-3.8.8" >> /home/ec2-user/.bash_profile
sudo echo "export PATH=/opt/apache-maven-3.8.8/bin:$PATH" >> /home/ec2-user/.bash_profile
source /home/ec2-user/.bash_profile
mvn --version
