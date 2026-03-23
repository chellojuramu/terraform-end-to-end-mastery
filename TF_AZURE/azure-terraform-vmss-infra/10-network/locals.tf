locals {
  resource_group_name  = "rg-${var.project}-${var.env}"
  vnet_name           = "vnet-${var.project}-${var.env}"

  app_subnet_name     = "app-subnet"
    mgmt_subnet_name    = "mgmt-subnet"
  common_tags         = {
    project = var.project
    env     = var.env
    terraform = "true"
  }
}