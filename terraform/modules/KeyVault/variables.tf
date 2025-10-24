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
