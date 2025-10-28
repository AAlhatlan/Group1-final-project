variable "prefix" {
  description = "Prefix used to build resource names."
  type        = string
}

variable "location" {
  description = "Azure region where the key vault will be created."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that will contain the key vault."
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID that owns the key vault."
  type        = string
}

variable "key_vault_name" {
  description = "Optional explicit key vault name (3-24 alphanumeric characters). Leave empty to auto-generate from the prefix."
  type        = string
  default     = ""

  validation {
    condition     = var.key_vault_name == "" || can(regex("^([a-zA-Z0-9]{3,24})$", var.key_vault_name))
    error_message = "key_vault_name must be empty or 3-24 alphanumeric characters without symbols."
  }
}

variable "name_suffix" {
  description = "Suffix used when auto-generating the key vault name."
  type        = string
  default     = "kv"
}

variable "sku_name" {
  description = "Key vault SKU tier."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], lower(var.sku_name))
    error_message = "sku_name must be either standard or premium."
  }
}

variable "soft_delete_retention_days" {
  description = "Number of days soft-deleted items are retained (7-90)."
  type        = number
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "purge_protection_enabled" {
  description = "Enable purge protection for the key vault."
  type        = bool
  default     = true
}

variable "enabled_for_disk_encryption" {
  description = "Allow the key vault to be used for disk encryption."
  type        = bool
  default     = false
}

variable "enabled_for_deployment" {
  description = "Allow the key vault to be used for Azure Resource Manager deployments."
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Allow the key vault to be used in template deployments."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Allow public network access to the key vault."
  type        = bool
  default     = true
}

variable "access_policies" {
  description = "List of access policies to assign to the key vault."
  type = list(object({
    tenant_id               = string
    object_id               = string
    application_id          = optional(string)
    certificate_permissions = optional(list(string))
    key_permissions         = optional(list(string))
    secret_permissions      = optional(list(string))
    storage_permissions     = optional(list(string))
  }))
  default = []
}

variable "secrets" {
  description = "Map of Key Vault secrets to create."
  type = map(object({
    value        = string
    content_type = optional(string)
    tags         = optional(map(string))
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to the key vault."
  type        = map(string)
  default     = {}
}
