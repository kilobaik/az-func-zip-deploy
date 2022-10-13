variable "name" {
  type        = string
  description = "The name of the storage account"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the storage account"
}

variable "location" {
  type        = string
  description = "The location/region where the storage account is created"
}

variable "account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account"
  default     = "Standard"
}

variable "access_tier" {
  type        = string
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts"
  default     = "Hot"
}

variable "account_kind" {
  type        = string
  description = "Defines the Kind of account."
  default     = "StorageV2"
}

variable "replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account"
  default     = "LRS"
}

variable "tags" {
  type        = map(string)
  description = "The tags to associate with this storage account"
  default     = {}
}