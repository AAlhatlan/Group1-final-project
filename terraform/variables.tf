variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "capstone"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "austriaeast"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-capstone"
}

variable "vnet_address_space" {
  description = "VNet address space"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aks_node_count" {
  description = "Default number of nodes"
  type        = number
  default     = 2
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "aks_min_count" {
  description = "Minimum nodes for autoscaler"
  type        = number
  default     = 2
}

variable "aks_max_count" {
  description = "Maximum nodes for autoscaler"
  type        = number
  default     = 5
}

variable "sql_admin" {
  description = "SQL admin username"
  type        = string
}

variable "sql_password" {
  description = "SQL admin password"
  type        = string
  sensitive   = true
}

variable "key_vault_name" {
  description = "Optional explicit name for the Key Vault (3-24 alphanumeric characters)."
  type        = string
  default     = ""

  validation {
    condition     = var.key_vault_name == "" || can(regex("^([a-zA-Z0-9]{3,24})$", var.key_vault_name))
    error_message = "key_vault_name must be empty or 3-24 alphanumeric characters without symbols."
  }
}

variable "key_vault_name_suffix" {
  description = "Suffix used when auto-generating the Key Vault name."
  type        = string
  default     = "kv"
}

variable "key_vault_sku_name" {
  description = "Key Vault SKU tier."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], lower(var.key_vault_sku_name))
    error_message = "key_vault_sku_name must be either standard or premium."
  }
}

variable "key_vault_soft_delete_retention_days" {
  description = "Number of days soft-deleted Key Vault items are retained (7-90)."
  type        = number
  default     = 90

  validation {
    condition     = var.key_vault_soft_delete_retention_days >= 7 && var.key_vault_soft_delete_retention_days <= 90
    error_message = "key_vault_soft_delete_retention_days must be between 7 and 90."
  }
}

variable "key_vault_purge_protection_enabled" {
  description = "Enable purge protection for the Key Vault."
  type        = bool
  default     = true
}

variable "key_vault_public_network_access_enabled" {
  description = "Allow public network access to the Key Vault."
  type        = bool
  default     = true
}

variable "key_vault_enabled_for_disk_encryption" {
  description = "Allow usage of the Key Vault for disk encryption."
  type        = bool
  default     = false
}

variable "key_vault_enabled_for_deployment" {
  description = "Allow Azure Resource Manager deployments to retrieve secrets from the Key Vault."
  type        = bool
  default     = false
}

variable "key_vault_enabled_for_template_deployment" {
  description = "Allow template deployments to access the Key Vault."
  type        = bool
  default     = false
}

variable "key_vault_access_policies" {
  description = "List of access policies to assign to the Key Vault."
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

variable "key_vault_tags" {
  description = "Tags to apply to the Key Vault."
  type        = map(string)
  default     = {}
}

variable "frontdoor_enabled" {
  description = "Enable Azure Front Door"
  type        = bool
  default     = true
}

variable "frontdoor_backend_host_name" {
  description = "Backend host for Front Door (leave empty to auto-use Static IP + nip.io)"
  type        = string
  default     = ""
}

variable "frontdoor_origin_host_header" {
  description = "Optional origin host header"
  type        = string
  default     = ""
}

variable "frontdoor_health_probe_path" {
  description = "Health probe path"
  type        = string
  default     = "/"
}

variable "ingress_static_ip_domain_label" {
  description = "Optional domain label for Static IP (creates FQDN)"
  type        = string
  default     = ""
}
