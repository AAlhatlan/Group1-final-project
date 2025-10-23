output "acr_id" {
  value = module.acr.acr_id
}

output "sql_fqdn" {
  value = module.sql.sql_server_fqdn
}

output "sql_db_name" {
  value = module.sql.database_name
}

output "ingress_ip" {
  value = module.public_ip.ip_address
}

output "managed_disk_id" {
  value = azurerm_managed_disk.app_disk.id
}