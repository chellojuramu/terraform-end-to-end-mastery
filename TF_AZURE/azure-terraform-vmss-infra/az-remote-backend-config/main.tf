resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags = local.common_tags
}

resource "azurerm_storage_account" "storage" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    prevent_destroy = false
  }
  tags = merge(
    local.common_tags,
    {
      Name = local.storage_name_tag
    }
  )
}

resource "azurerm_storage_container" "container" {
  name                  = local.container_name
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}
