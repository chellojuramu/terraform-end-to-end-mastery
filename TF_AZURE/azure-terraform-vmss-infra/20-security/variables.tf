variable "project" {
  default = "azure-terraform-vmss-infra"
}
variable "env" {
  default = "dev"
}
variable "location" {
  default = "centralindia"
}
# NSG rules input (dynamic)
variable "nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    port                       = string
    source                    = string
  }))
}