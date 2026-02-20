resource "aws_instance" "example" {
  # Create 10 instances based on the length of the list
  count = length(var.instances)

  ami                    = "ami-0220d79f3f480ecf5"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    # Dynamically pick name from the list: mongodb, redis, etc.
    Name    = var.instances[count.index]
    Project = "roboshop"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-roboshop" # this is for AWS account
  description = "Allow TLS inbound traffic and all outbound traffic"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-all-terraform"
  }
}