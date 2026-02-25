resource "aws_instance" "example" {
  # Instead of hardcoding, we ask the local brain for the ID and type
  ami           = local.ami_id
  instance_type = local.instance_type

  # Connects the security group (assuming you have one defined)
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  # All the merging work was already finished in the locals file
  tags = local.ec2_final_tags
}

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform"
  description = "Security group for locals demo"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-all-terraform"
  }
}