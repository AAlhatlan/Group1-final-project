variable "prefix" {
  description = "Prefix for resources"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "aks_managed_identity_id" {
  description = "Managed Identity ID of AKS for Key Vault access"
  type        = string
}

variable "sql_admin_username" {
  description = "SQL admin username to store in Key Vault"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL admin password to store in Key Vault"
  type        = string
  sensitive   = true
}
