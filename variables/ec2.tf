# --- RESOURCE 1: THE SERVER ---
resource "aws_instance" "web" {
  ami           = var.ami_id        # NO QUOTES here
  instance_type = var.instance_type # NO QUOTES here

  # LINKING: This connects your server to your firewall
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = var.ec2_tags
}

# --- RESOURCE 2: THE FIREWALL ---
resource "aws_security_group" "allow_tls" {
  name        = var.sg_name
  description = var.sg_description

  # These MUST be inside the security group braces
  egress {
    from_port        = var.sg_from_port
    to_port          = var.sg_to_port
    protocol         = "-1"
    cidr_blocks      = var.cidr_blocks
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = var.sg_from_port
    to_port          = var.sg_to_port
    protocol         = "-1"
    cidr_blocks      = var.cidr_blocks
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.sg_tags
} # This closing brace ends the security group