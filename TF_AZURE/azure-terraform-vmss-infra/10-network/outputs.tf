output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "mgmt_subnet_id" {
  value = azurerm_subnet.mgmt.id
}