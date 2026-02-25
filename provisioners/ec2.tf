resource "aws_instance" "example" {
  ami           = "ami-0220d79f3f480ecf5" # Ensure this is correct for your region
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  # --- LOCAL-EXEC PROVISIONERS (Runs on YOUR machine) ---

  # Task 1: Create an inventory file for Ansible or records
  provisioner "local-exec" {
    # self refers to THIS aws_instance
    command = "echo ${self.public_ip} > inventory.ini"
  }

  # Task 2: Handling Failures
  provisioner "local-exec" {
    command = "exit 1" # This command deliberately fails
    on_failure = continue # Terraform will ignore the error and keep going
  }

  # Task 3: Destroy-time provisioner (Cleans up your laptop)
  provisioner "local-exec" {
    when    = destroy
    command = "echo '' > inventory.ini" # Clears the file when instance is deleted
  }

  # --- REMOTE-EXEC PROVISIONERS (Runs on the AWS Instance) ---

  # Step A: Define HOW to connect to the server
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321" # Note: In production, use private_key
    host     = self.public_ip
  }

  # Step B: Install software inside the server
  provisioner "remote-exec" {
    inline = [
      "sudo dnf install nginx -y",
      "sudo systemctl start nginx"
    ]
  }

  # Step C: Cleanup software during destroy
  provisioner "remote-exec" {
    when = destroy
    inline = [
      "sudo systemctl stop nginx"
    ]
  }

  tags = {
    Name = "provisioners-demo"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform"
  description = "IMPORTANT: Port 22 must be open for provisioners to work"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22 # Required for SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80 # Required to see Nginx working
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}