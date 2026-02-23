resource "aws_instance" "example" {
  # toset converts our list into a unique collection that for_each can use
  # It creates a loop: "For each name in the set, do the following..."
  for_each = toset(var.instances)

  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"

  # Connects the security group we created (referencing the ID)
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    # each.key represents the current name in the loop (e.g., "mongodb")
    Name    = each.key
    Project = "roboshop"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform"
  description = "Allow all inbound and outbound traffic"

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
}