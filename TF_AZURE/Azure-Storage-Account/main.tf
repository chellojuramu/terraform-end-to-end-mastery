resource "azurerm_resource_group" "main" {
  name     = "terraform-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "storage" {
  depends_on = [azurerm_resource_group.main] #explicit dependency
  name                     = "ramuchelloju101"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location #implicit dependency
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.storage-account}"
    }
  )
}