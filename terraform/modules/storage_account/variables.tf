variable "prefix" {
  description = "Prefix used to build the storage account name."
  type        = string
}

variable "location" {
  description = "Azure region for the storage account."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the storage account will be created."
  type        = string
}

variable "storage_account_name" {
  description = "Optional explicit storage account name (3-24 lowercase alphanumeric). Leave empty to auto-generate from prefix."
  type        = string
  default     = ""

  validation {
    condition     = var.storage_account_name == "" || can(regex("^([a-z0-9]{3,24})$", var.storage_account_name))
    error_message = "storage_account_name must be empty or between 3 and 24 lowercase alphanumeric characters."
  }
}

variable "name_suffix" {
  description = "Suffix appended to the prefix when generating the storage account name."
  type        = string
  default     = "storage"
}

variable "account_tier" {
  description = "Storage account tier."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "account_tier must be either Standard or Premium."
  }
}

variable "account_replication_type" {
  description = "Replication strategy for the storage account."
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "account_replication_type must be one of LRS, GRS, RAGRS, ZRS, GZRS, or RAGZRS."
  }
}

variable "access_tier" {
  description = "Access tier for Blob storage."
  type        = string
  default     = "Hot"

  validation {
    condition     = contains(["Hot", "Cool"], var.access_tier)
    error_message = "access_tier must be Hot or Cool."
  }
}

variable "min_tls_version" {
  description = "Minimum TLS version allowed for requests."
  type        = string
  default     = "TLS1_2"

  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "min_tls_version must be TLS1_0, TLS1_1, or TLS1_2."
  }
}

variable "allow_blob_public_access" {
  description = "Whether to allow public blob access."
  type        = bool
  default     = false
}

variable "enable_https_traffic_only" {
  description = "Force HTTPS when communicating with the storage account."
  type        = bool
  default     = true
}

variable "kind" {
  description = "Storage account kind."
  type        = string
  default     = "StorageV2"

  validation {
    condition     = contains(["Storage", "StorageV2", "BlobStorage", "BlockBlobStorage", "FileStorage"], var.kind)
    error_message = "kind must be one of Storage, StorageV2, BlobStorage, BlockBlobStorage, or FileStorage."
  }
}

variable "tags" {
  description = "Tags to apply to the storage account."
  type        = map(string)
  default     = {}
}
