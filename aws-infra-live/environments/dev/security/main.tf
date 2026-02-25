terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}
####################################
# Remote State: Fetch Network Outputs
########################################

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-state-file-s3-23022026"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_security_group" "app_sg" {
  name = "${var.environment}-app-sg"
  description = "security group for application servers in ${var.environment} environment"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH from my IP"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.environment
    Layer = "Security"
    Name = "${var.environment}-app-sg"
  }
}

resource "aws_security_group" "db_sg" {
  name = "${var.environment}-db-sg"
  description = "Security Group for database"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  ingress {
    description = "Allow MySQL from app security group"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
  # SSH from YOUR IP
  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.environment
    Layer = "Security"
    Name = "${var.environment}-db-sg"
  }
}