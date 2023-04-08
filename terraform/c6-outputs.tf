# Output values

# Attribute Reference - Public IP
output "jenkins_ec2_instance_publicip" {
  description = "Jenkins EC2 Instance Public IP"
  value       = aws_instance.jenkins-amzn-ec2-vm.public_ip
}

output "docker_ec2_instance_publicip" {
  description = "Docker Host EC2 Instance Public IP"
  value       = aws_instance.docker-amzn-ec2-vm.public_ip
}

output "ansible_ec2_instance_publicip" {
  description = "Ansible EC2 Instance Public IP"
  value       = aws_instance.ansible-amzn-ec2-vm.public_ip
}

# Attribute Reference - Public DNS URL
output "jenkins_ec2_publicdns" {
  description = "Jenkins Public DNS URL of an EC2 Instance"
  value       = aws_instance.jenkins-amzn-ec2-vm.public_dns
}

output "docker_ec2_publicdns" {
  description = "Docker Host Public DNS URL of an EC2 Instance"
  value       = aws_instance.docker-amzn-ec2-vm.public_dns
}

output "ansible_ec2_publicdns" {
  description = "Ansible Public DNS URL of an EC2 Instance"
  value       = aws_instance.ansible-amzn-ec2-vm.public_dns
}
