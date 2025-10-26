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

variable "sql_admin_username" {
  description = "SQL admin username"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL admin password"
  type        = string
  sensitive   = true
}

variable "subnet_id" {
  description = "Subnet ID for Private Endpoint"
  type        = string
}

variable "vnet_id" {
  description = "VNet ID for Private DNS link"
  type        = string
}
