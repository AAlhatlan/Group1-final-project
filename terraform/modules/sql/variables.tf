variable "prefix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
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