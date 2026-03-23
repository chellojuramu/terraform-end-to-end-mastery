locals {
  lb_name       = "lb-${var.project}-${var.env}"
  public_ip_name = "pip-${var.project}-${var.env}"
  backend_pool  = "backend-pool"

  common_tags = {
    project     = var.project
    environment = var.env
    terraform   = "true"
  }
}