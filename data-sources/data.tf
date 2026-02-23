# SEARCH for the latest RHEL 9 AMI
data "aws_ami" "Ramu" {
  most_recent = true
  owners      = ["973714476881"] # The specific AWS account owner

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# READ data from an existing instance (useful for cross-referencing)
data "aws_instance" "terraform_instance" {
  instance_id = "i-03cce376b8b4ecd8a"
}