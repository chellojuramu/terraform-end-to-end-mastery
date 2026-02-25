resource "aws_instance" "example" {
  ami                    = "ami-0220d79f3f480ecf5" # Replace with your dynamic AMI data later
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name    = "dynamic-demo"
    Project = "roboshop"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform"
  description = "Security group with dynamic ingress rules"

  # Egress is static because we usually allow all outbound traffic
  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  # DYNAMIC EGRESS BLOCK
  dynamic "egress" {
    for_each = var.egress_rules

    content {
      # egress.value is the "hand" holding the package from var.egress_rules
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  # DYNAMIC BLOCK: The "Loop" starts here
  dynamic "ingress" {
    # It looks at the 'ingress_rules' list in variables.tf
    for_each = var.ingress_rules

    content {
      # 'ingress.value' means "The current package I am holding"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  tags = {
    Name = "allow-all-terraform"
  }
}