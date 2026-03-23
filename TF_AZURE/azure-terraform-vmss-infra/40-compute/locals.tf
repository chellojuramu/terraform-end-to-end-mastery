locals {
  vmss_name = "vmss-${var.project}-${var.env}"

  common_tags = {
    project     = var.project
    environment = var.env
    terraform   = "true"
  }
}