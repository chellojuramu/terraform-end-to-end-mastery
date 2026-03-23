locals {
  nsg_name = "nsg-${var.project}-${var.env}"

  common_tags = {
    project     = var.project
    environment = var.env
    terraform   = "true"
  }
}