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

variable "vnet_address_space" {
  description = "VNet address space"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aks_subnet_prefix" {
  description = "Subnet prefix for AKS"
  type        = string
  default     = "10.0.1.0/24"
}

variable "sql_subnet_prefix" {
  description = "Subnet prefix for SQL/Private Endpoint"
  type        = string
  default     = "10.0.2.0/24"
}
