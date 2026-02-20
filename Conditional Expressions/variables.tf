variable "environment" {
  type        = string
  default     = "prod" # Default is prod; change to "dev" for smaller instances
  description = "Execution environment (dev/prod)"
}

variable "ami_id" {
  type    = string
  default = "ami-0220d79f3f480ecf5"
}

variable "ec2_tags" {
  type = map(string)
  default = {
    Project     = "roboshop"
    Terraform   = "true"
    Environment = "dev"
  }
}

# Network Variables
variable "sg_name" { default = "allow-all-terraform" }
variable "sg_from_port" { default = 0 }
variable "sg_to_port" { default = 0 }
variable "cidr_blocks" { default = ["0.0.0.0/0"] }
variable "sg_tags" {
  type = map(string)
  default = { Name = "allow-all-terraform" }
}