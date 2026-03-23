data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-tfstate-learndev-dev"
    storage_account_name = "tfstatelearndevdev"
    container_name       = "tfstate"
    key                  = "vmss/dev/10-network/terraform.tfstate"
  }
}
resource "azurerm_public_ip" "pip" {
  name                = local.public_ip_name
  location            = var.location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label = "${var.project}-${var.env}-lb"
  tags = local.common_tags
}
resource "azurerm_lb" "lb" {
  name                = local.lb_name
  location            = var.location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public-ip"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  tags = local.common_tags
}
resource "azurerm_lb_backend_address_pool" "pool" {
  name            = local.backend_pool
  loadbalancer_id = azurerm_lb.lb.id
}
resource "azurerm_lb_probe" "probe" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}
resource "azurerm_lb_rule" "http" {
  name                           = "http-rule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "public-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.pool.id]
  probe_id                       = azurerm_lb_probe.probe.id
}
resource "azurerm_lb_nat_rule" "ssh" {
  name                           = "ssh-rule"
  resource_group_name            = data.terraform_remote_state.network.outputs.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "public-ip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.pool.id
}
resource "azurerm_public_ip" "nat_pip" {
  name                = "nat-pip-${var.project}-${var.env}"
  location            = var.location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}
resource "azurerm_nat_gateway" "nat" {
  name                    = "nat-${var.project}-${var.env}"
  location                = var.location
  resource_group_name     = data.terraform_remote_state.network.outputs.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10

  tags = local.common_tags
}
resource "azurerm_nat_gateway_public_ip_association" "assoc" {
  public_ip_address_id = azurerm_public_ip.nat_pip.id
  nat_gateway_id       = azurerm_nat_gateway.nat.id
}
resource "azurerm_subnet_nat_gateway_association" "subnet_assoc" {
  subnet_id = data.terraform_remote_state.network.outputs.app_subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}