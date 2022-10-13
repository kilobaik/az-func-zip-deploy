locals {
  location            = "West Europe"
  resource_group_name = "test-rg-2"

  tags = {
    source = "local_test"
    owner  = "Mohamad Karam Kassem"
  }
}

module "storage" {
  source = "../../modules/storage_account"

  name                = replace("sa-u4-az-func-app-http", "-", "")
  resource_group_name = local.resource_group_name
  location            = local.location

  tags = local.tags
}

module "function_app" {
  source = "../../modules/function_app"

  name                = "az-func-app-http"
  resource_group_name = local.resource_group_name
  location            = local.location

  storage_account_name              = module.storage.name
  storage_account_access_key        = module.storage.primary_access_key
  storage_account_connection_string = module.storage.primary_connection_string
  function_code_dir                 = abspath("../functions")
}
