variable "name" {
  type        = string
  default     = "roboshop"
}

variable "environment" {
  type        = string
  default     = "dev"
}

variable "ec2_tags" {
  type = map(string)
  default = {
    Component = "backend"
    Task      = "locals-testing"
    Environment = "prod"
  }
}