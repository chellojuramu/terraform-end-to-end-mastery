variable "project" {}
variable "env" {
  default = "dev"
}
variable "location" {}

variable "vm_sizes" {
  default = {
    dev = "Standard_D2s_v4"


  }
}

variable "instance_count" {
  default = 2
}
variable "admin_password" {
  type      = string
  sensitive = true
}