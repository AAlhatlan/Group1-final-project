variable "resource_group_name" {
  default = "rg-demo"
}

variable "location" {
  default = "eastus"
}

variable "db_admin_username" {
  description = "اسم المستخدم لقاعدة البيانات"
}

variable "db_admin_password" {
  description = "كلمة المرور لقاعدة البيانات"
  sensitive   = true
}