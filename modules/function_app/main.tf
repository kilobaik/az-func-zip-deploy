resource "azurerm_service_plan" "service_plan" {
  name                = "${var.name}-service-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v2"
  worker_count        = 1

  tags = merge(var.tags, local.common_tags)
}

resource "azurerm_linux_function_app" "function_app" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  https_only                 = true
  service_plan_id            = azurerm_service_plan.service_plan.id
  tags                       = merge(var.tags, local.common_tags)

  app_settings = {
    FUNCTIONS_EXTENSION_VERSION     = "~4"
    AzureWebJobsStorage             = var.storage_account_connection_string
    AZURE_STORAGE_CONNECTION_STRING = var.storage_account_connection_string
  }

  site_config {

    application_stack {
      python_version = "3.9"
    }
  }
}