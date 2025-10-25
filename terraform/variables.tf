variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "capstone"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "indonesiacentral"
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
  default     = "Standard_E2bds_v5"
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
  default     = "sqladmin"
}

variable "sql_password" {
  description = "SQL admin password"
  type        = string
  sensitive   = true
}

variable "random_suffix_length" {
  description = "Length of the random suffix appended to resource names"
  type        = number
  default     = 4

  validation {
    condition     = var.random_suffix_length >= 3 && var.random_suffix_length <= 8
    error_message = "random_suffix_length must be between 3 and 8 to keep names short yet unique."
  }
}
