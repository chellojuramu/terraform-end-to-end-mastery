variable "project" {
  default = "azure-terraform-vmss-infra"
}
variable "env" {
  default = "dev"
}
variable "location" {
  default = "centralindia"
}

variable "vnet_address_space" {
  default = ["10.0.0.0/16"]
}

variable "app_subnet_cidr" {
  default = ["10.0.1.0/24"]
}

variable "mgmt_subnet_cidr" {
  default = ["10.0.2.0/24"]
}