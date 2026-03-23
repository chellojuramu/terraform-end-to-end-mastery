output "vmss_id" {
  value = azurerm_orchestrated_virtual_machine_scale_set.vmss.id
}

output "resource_group_name" {
  value = data.terraform_remote_state.network.outputs.resource_group_name
}