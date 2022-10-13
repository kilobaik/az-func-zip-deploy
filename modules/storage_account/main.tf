resource "azurerm_storage_account" "storage_account" {

  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = var.account_tier
  account_kind              = var.account_kind
  account_replication_type  = var.replication_type
  enable_https_traffic_only = true
  tags                      = merge(var.tags, local.common_tags)
}

resource "azurerm_storage_container" "default_container" {
  name                  = "default"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}