variable "sql_server_name" {
  description = "اسم Azure SQL Server"
}

variable "db_name" {
  description = "اسم قاعدة البيانات"
}

variable "location" {
  description = "الموقع الجغرافي"
}

variable "resource_group_name" {
  description = "اسم الـResource Group"
}

variable "admin_username" {
  description = "اسم المستخدم للسيرفر"
}

variable "admin_password" {
  description = "كلمة المرور للسيرفر"
  sensitive   = true
}

variable "subnet_id" {
  description = "ID الخاص بالـSubnet اللي يُسمح منها بالوصول"
}