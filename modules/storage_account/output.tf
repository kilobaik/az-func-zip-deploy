output "id" {
  value       = azurerm_storage_account.storage_account.id
  description = "The storage account id"
}

output "name" {
  value       = azurerm_storage_account.storage_account.name
  description = "The name of the storage account"
}

output "primary_connection_string" {
  value       = azurerm_storage_account.storage_account.primary_connection_string
  description = "The connection string associated with the primary location"
}

output "primary_access_key" {
  value       = azurerm_storage_account.storage_account.primary_access_key
  description = "The primary access key for the storage account"
}
