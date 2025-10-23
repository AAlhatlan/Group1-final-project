output "sql_server_name" {
  description = "اسم السيرفر"
  value       = azurerm_mssql_server.sql_server.name
}

output "sql_server_fqdn" {
  description = "FQDN للسيرفر"
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}

output "sql_db_name" {
  description = "اسم قاعدة البيانات"
  value       = azurerm_mssql_database.sql_db.name
}