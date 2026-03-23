variable "project" {}
variable "env" {}
variable "location" {}

variable "min_instances" {
  default = 2
}

variable "max_instances" {
  default = 5
}

variable "default_instances" {
  default = 2
}