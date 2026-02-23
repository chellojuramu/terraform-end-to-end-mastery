resource "aws_instance" "example" {
  # DYNAMIC: No more hardcoded AMI IDs!
  ami           = data.aws_ami.Ramu.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name    = "terraform-data-test"
    Project = "roboshop"
    # Even adding a tag from the existing instance data
    Reference_AZ = data.aws_instance.terraform_instance.availability_zone
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