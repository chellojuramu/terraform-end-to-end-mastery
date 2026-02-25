resource "aws_instance" "example" {
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  # MERGE LOGIC:
  # 1. Takes everything from common_tags
  # 2. Adds everything from ec2_tags
  # 3. If a key (like Environment) exists in both, the second one wins.
  tags = merge(
    var.common_tags,
    var.ec2_tags
  )
}

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform"
  description = "Allow all traffic"

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

  # Resulting tags will be: Project, Terraform, Environment, and Name
  tags = merge(
    var.common_tags,
    var.sg_tags
  )
}