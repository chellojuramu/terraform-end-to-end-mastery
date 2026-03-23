data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-tfstate-learndev-dev"
    storage_account_name = "tfstatelearndevdev"
    container_name       = "tfstate"
    key                  = "vmss/dev/10-network/terraform.tfstate"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = local.nsg_name
  location            = var.location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name

  tags = local.common_tags
  dynamic "security_rule" {
    for_each = var.nsg_rules

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.port
      source_address_prefix = security_rule.value.source
      destination_address_prefix = "*"
    }
  }
}
resource "azurerm_subnet_network_security_group_association" "assoc" {
  subnet_id                 = data.terraform_remote_state.network.outputs.app_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}