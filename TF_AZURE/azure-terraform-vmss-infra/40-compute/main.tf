data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-tfstate-learndev-dev"
    storage_account_name = "tfstatelearndevdev"
    container_name       = "tfstate"
    key                  = "vmss/dev/10-network/terraform.tfstate"
  }
}

data "terraform_remote_state" "lb" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-tfstate-learndev-dev"
    storage_account_name = "tfstatelearndevdev"
    container_name       = "tfstate"
    key                  = "vmss/dev/30-loadbalancer/terraform.tfstate"
  }
}
resource "azurerm_orchestrated_virtual_machine_scale_set" "vmss" {
  name                = local.vmss_name
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  location            = var.location

  sku_name  = lookup(var.vm_sizes, var.env)
  instances = var.instance_count

  platform_fault_domain_count = 1
  zones = ["1"]

  user_data_base64 = base64encode(file("user-data.sh"))

  os_profile {
    linux_configuration {
      disable_password_authentication = false
      admin_username                  = "azureuser"
      admin_password = var.admin_password
    }
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-LTS-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic"
    primary = true

    ip_configuration {
      name      = "ipconfig"
      primary   = true
      subnet_id = data.terraform_remote_state.network.outputs.app_subnet_id

      load_balancer_backend_address_pool_ids = [
        data.terraform_remote_state.lb.outputs.lb_backend_pool_id
      ]
    }
  }

  lifecycle {
    ignore_changes = [instances]
  }

  tags = local.common_tags
}