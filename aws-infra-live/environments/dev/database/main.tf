terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "terraform-state-file-s3-23022026"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = "terraform-state-file-s3-23022026"
    key    = "dev/security/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "db" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id = data.terraform_remote_state.network.outputs.private_subnet_ids[0]
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs.db_sg_id]
  associate_public_ip_address = false
  key_name = "daws-88s"

  user_data = <<-EOF
#!/bin/bash
dnf update -y

# Install MariaDB (Amazon Linux 2023)
dnf install -y mariadb105-server

# Enable & start service
systemctl enable mariadb
systemctl start mariadb

# Allow root remote access (DEV only - not production safe)
mysql -u root <<SQL
CREATE DATABASE IF NOT EXISTS devdb;
CREATE USER 'root'@'%' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
FLUSH PRIVILEGES;
SQL
EOF
  tags = {
    Environment = var.environment
    Layer       = "database"
    Name        = "${var.environment}-db-ec2"
  }
}