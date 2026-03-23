data "terraform_remote_state" "compute" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-tfstate-learndev-dev"
    storage_account_name = "tfstatelearndevdev"
    container_name       = "tfstate"
    key                  = "vmss/dev/40-compute/terraform.tfstate"
  }
}
resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "autoscale-${var.project}-${var.env}"
  location            = var.location
  resource_group_name = data.terraform_remote_state.compute.outputs.resource_group_name
  target_resource_id  = data.terraform_remote_state.compute.outputs.vmss_id
  enabled             = true

  profile {
    name = "cpu-autoscale"

    capacity {
      default = var.default_instances
      minimum = var.min_instances
      maximum = var.max_instances
    }

    # 🔥 SCALE OUT (CPU > 80%)
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = data.terraform_remote_state.compute.outputs.vmss_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    # 🔥 SCALE IN (CPU < 10%)
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = data.terraform_remote_state.compute.outputs.vmss_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 10
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}