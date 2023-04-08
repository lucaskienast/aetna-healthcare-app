# Create EC2 Instance - Amazon Linux
resource "aws_instance" "jenkins-amzn-ec2-vm" {
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type
  key_name               = "terraform-key"
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  user_data              = file("./bash-scripts/install-jenkins.sh")
  tags = {
    "Name" = "jenkins-amzn-linux-vm"
  }
}

resource "aws_instance" "docker-amzn-ec2-vm" {
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type
  key_name               = "terraform-key"
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  user_data              = file("./bash-scripts/install-docker.sh")
  depends_on             = [aws_instance.jenkins-amzn-ec2-vm]
  tags = {
    "Name" = "docker-amzn-linux-vm"
  }
}

resource "aws_instance" "k8-amzn-ec2-vm" {
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type
  key_name               = "terraform-key"
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  user_data              = file("./bash-scripts/install-k8.sh")
  depends_on             = [aws_instance.jenkins-amzn-ec2-vm]
  tags = {
    "Name" = "k8-amzn-linux-vm"
  }
}

resource "aws_instance" "ansible-amzn-ec2-vm" {
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type
  key_name               = "terraform-key"
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  depends_on             = [aws_instance.docker-amzn-ec2-vm, aws_instance.k8-amzn-ec2-vm]
  tags = {
    "Name" = "ansible-amzn-linux-vm"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("./private-key/terraform-key.pem")
  }

  provisioner "file" {
    source      = "./bash-scripts/install-ansible.sh"
    destination = "/tmp/install-ansible.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-ansible.sh",
      "/tmp/install-ansible.sh ${aws_instance.docker-amzn-ec2-vm.private_ip} ${aws_instance.k8-amzn-ec2-vm.private_ip}"
    ]
  }
}
