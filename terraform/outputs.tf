# 🗺️ الشبكة
output "vnet_id" {
  description = "ID الخاص بالـVirtual Network"
  value       = module.network.vnet_id
}

output "aks_subnet_id" {
  description = "ID الخاص بالـSubnet الخاصة بالـAKS"
  value       = module.network.aks_subnet_id
}

output "db_subnet_id" {
  description = "ID الخاص بالـSubnet الخاصة بالـSQL Server"
  value       = module.network.db_subnet_id
}

# ☸️ الكلاستر
output "aks_kube_config" {
  description = "Kubeconfig للاتصال بالـAKS Cluster"
  value       = module.cluster.kube_config
  sensitive   = true
}

# 🗄️ قاعدة البيانات (Azure SQL)
output "sql_server_name" {
  description = "اسم Azure SQL Server"
  value       = module.database.sql_server_name
}

output "sql_server_fqdn" {
  description = "الـFQDN (نقطة الاتصال العامة) لـ Azure SQL Server"
  value       = module.database.sql_server_fqdn
}

output "sql_database_name" {
  description = "اسم قاعدة البيانات داخل السيرفر"
  value       = module.database.sql_db_name
}