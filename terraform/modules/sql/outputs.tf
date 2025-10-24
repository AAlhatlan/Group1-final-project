output "sql_server_name" {
  value = azurerm_sql_server.main.name
}

output "sql_database_name" {
  value = azurerm_sql_database.main.name
}

output "sql_fqdn" {
  value = azurerm_sql_server.main.fully_qualified_domain_name
}

output "private_endpoint_id" {
  value = azurerm_private_endpoint.sql.id
}
