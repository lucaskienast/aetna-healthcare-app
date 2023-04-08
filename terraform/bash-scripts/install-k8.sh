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

# Update AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo reboot

# Install kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.7/2022-10-31/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Create cluster and nodes
eksctl create cluster --name aetna  \
--region us-east-1 \
--node-type t2.small

# Create deployment
touch /home/ec2-user/aetna-deployment.yml
sudo echo "apiVersion: apps/v1 " >> /home/ec2-user/aetna-deployment.yml
sudo echo "kind: Deployment " >> /home/ec2-user/aetna-deployment.yml
sudo echo "metadata: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "  name: lucas-aetna " >> /home/ec2-user/aetna-deployment.yml
sudo echo "  labels: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "     app: aetna " >> /home/ec2-user/aetna-deployment.yml
sudo echo "spec: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "  replicas: 3 " >> /home/ec2-user/aetna-deployment.yml
sudo echo "  selector: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "     matchLabels: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "      app: aetna " >> /home/ec2-user/aetna-deployment.yml
sudo echo "  template: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "     metadata: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "      labels: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "        app: aetna " >> /home/ec2-user/aetna-deployment.yml
sudo echo "     spec: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "      containers: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "      - name: aetna " >> /home/ec2-user/aetna-deployment.yml
sudo echo "        image: lucaskienast/aetna " >> /home/ec2-user/aetna-deployment.yml
sudo echo "        imagePullPolicy: Always " >> /home/ec2-user/aetna-deployment.yml
sudo echo "        ports: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "        - containerPort: 8080 " >> /home/ec2-user/aetna-deployment.yml
sudo echo "  strategy: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "    type: RollingUpdate " >> /home/ec2-user/aetna-deployment.yml
sudo echo "    rollingUpdate: " >> /home/ec2-user/aetna-deployment.yml
sudo echo "      maxSurge: 1 " >> /home/ec2-user/aetna-deployment.yml
sudo echo "      maxUnavailable: 1 " >> /home/ec2-user/aetna-deployment.yml

# Create service
touch /home/ec2-user/aetna-service.yml
sudo echo "apiVersion: apps/v1 " >> /home/ec2-user/aetna-service.yml
sudo echo "kind: Service " >> /home/ec2-user/aetna-service.yml
sudo echo "metadata: " >> /home/ec2-user/aetna-service.yml
sudo echo "  name: lucas-service " >> /home/ec2-user/aetna-service.yml
sudo echo "  labels: " >> /home/ec2-user/aetna-service.yml
sudo echo "     app: aetna " >> /home/ec2-user/aetna-service.yml
sudo echo "spec: " >> /home/ec2-user/aetna-service.yml
sudo echo "  selector: " >> /home/ec2-user/aetna-service.yml
sudo echo "    app: aetna " >> /home/ec2-user/aetna-service.yml
sudo echo "  ports: " >> /home/ec2-user/aetna-service.yml
sudo echo "    - port: 8080 " >> /home/ec2-user/aetna-service.yml
sudo echo "      targetPort: 8080 " >> /home/ec2-user/aetna-service.yml
sudo echo "  type: LoadBalancer " >> /home/ec2-user/aetna-service.yml
