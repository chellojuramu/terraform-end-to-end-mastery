variable "common_tags" {
  type = map(string)
  default = {
    Project     = "roboshop"
    Terraform   = "true"
    Environment = "dev" # This is the 'Base' environment
  }
}

variable "ec2_tags" {
  type = map(string)
  default = {
    Name        = "functions-demo"
    Environment = "prod" # This will OVERRIDE 'dev' because it's merged second
  }
}

variable "sg_tags" {
  type = map(string)
  default = {
    Name = "allow-all-terraform"
  }
}