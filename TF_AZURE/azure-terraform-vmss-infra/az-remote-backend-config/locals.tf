locals {
  resource_group_name  = "rg-tfstate-${var.project}-${var.env}"

  # Storage account must be lowercase + no hyphens
  storage_account_name = "tfstate${var.project}${var.env}"

  container_name       = "tfstate"

  common_tags = {
    Project     = var.project
    Environment = var.env
    Terraform   = "true"
  }

  storage_name_tag = "${var.project}-${var.env}-${local.storage_account_name}"
}