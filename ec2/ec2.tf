# --- RESOURCE 1: THE FIREWALL (Security Group) ---
resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform"
  description = "Security group for Roboshop dev environment"

  # Egress: Outgoing traffic (From Server to Internet)
  egress {
    from_port        = 0    # Starting at port 0
    to_port          = 0    # Ending at port 0
    protocol         = "-1" # "-1" means ALL PROTOCOLS (TCP, UDP, ICMP, etc.)
    cidr_blocks      = ["0.0.0.0/0"] # Destination: The whole internet
    ipv6_cidr_blocks = ["::/0"]      # Destination: IPv6 whole internet
  }

  # Ingress: Incoming traffic (From Internet to Server)
  ingress {
    from_port        = 0    # Starting at port 0
    to_port          = 0    # Ending at port 0
    protocol         = "-1" # "-1" means EVERYTHING is open. No doors are locked.
    cidr_blocks      = ["0.0.0.0/0"] # Source: Anyone in the world can connect
    ipv6_cidr_blocks = ["::/0"]      # Source: IPv6 anyone can connect
  }

  tags = {
    Name = "allow-all-terraform"
  }
}

# --- RESOURCE 2: THE SERVER (EC2 Instance) ---
resource "aws_instance" "example" {
  ami           = "ami-0220d79f3f480ecf5" # The OS (Operating System) ID
  instance_type = "t3.micro"               # The hardware power (CPU/RAM)

  # LINKING: This line tells the EC2 to use the SG created above.
  # It fetches the unique ID of the 'allow_tls' resource automatically.
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name    = "terraform-beast" # Label for the AWS Console
    Project = "roboshop"       # Label for billing/tracking
  }
}