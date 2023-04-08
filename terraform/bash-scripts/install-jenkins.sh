#!/bin/bash

# Update System
sudo yum update -y

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
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
apache-maven-3.8.7-bin.tar.gz
sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.7/binaries/apache-maven-3.8.7-bin.tar.gz
sudo tar -xvzf apache-maven-3.8.7-bin.tar.gz
mv apache-maven-3.8.7 /opt/
sudo echo "export M2_HOME=/opt/apache-maven-3.8.7" >> /home/ec2-user/.bash_profile
sudo echo "export PATH=/opt/apache-maven-3.8.7/bin:$PATH" >> /home/ec2-user/.bash_profile
source /home/ec2-user/.bash_profile
mvn --version
