variable "ami_id" {
  type        = string
  default     = "ami-0220d79f3f480ecf5"
  description = "The ID of the AMI to use for the EC2 instance (RHEL 9)"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "The type of instance to use (e.g., t3.micro, t3.small)"
}

variable "ec2_tags" {
  type = map(string) # Defining that this map contains strings
  default = {
    Name        = "variables-demo"
    Project     = "roboshop"
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "sg_name" {
  type    = string
  default = "allow-all-terraform-default"
}

variable "sg_description" {
  type    = string
  default = "Allow TLS inbound traffic and outbound traffic for all protocols and ports"
}

variable "sg_from_port" {
  type    = number
  default = 0
}

variable "sg_to_port" {
  type    = number
  default = 0
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "sg_tags" {
  type = map(string)
  default = {
    Name        = "allow-all-terraform-default"
    Project     = "roboshop"
    Terraform   = "true"
    Environment = "dev"
  }
}