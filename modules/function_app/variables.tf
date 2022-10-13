variable "name" {
  type        = string
  description = "The name of the function app (will be used as postfix for service plan as well)"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the function app and the corresponding service plan"
}

variable "location" {
  type        = string
  description = "The location/region where the function app and service plan is created"
}

variable "storage_account_name" {
  type        = string
  description = "The backend storage account name which will be used by this function app"
}

variable "storage_account_access_key" {
  type        = string
  description = "The access key which will be used to access the backend storage account for the function app"
}

variable "storage_account_connection_string" {
  type        = string
  description = "The connection strings for storage account"
}

variable "function_code_dir" {
  type        = string
  description = "Functions' codes directory for zip deployment"
}

variable "tags" {
  type        = map(string)
  description = "The tags to associate with these function app and service plan"
  default     = {}
}
