variable "prefix" {
  type = string
}

variable "location" {
  type    = string
  default = "indonesiacentral"
}

variable "resource_group_name" {
  type = string
}

variable "aks_cluster_name" {
  type = string
}

variable "sql_admin_login" {
  type      = string
  sensitive = true
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "disk_size_gb" {
  type    = number
  default = 10
}

variable "disk_sku" {
  type    = string
  default = "Standard_LRS"
}