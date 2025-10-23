resource "azurerm_mssql_server" "sql_server" {
  name                         = "${var.prefix}-sqlserver"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "sql_db" {
  name           = "${var.prefix}-sqldb"
  server_id      = azurerm_mssql_server.sql_server.id
  sku_name       = "Basic"
  max_size_gb    = 2
  zone_redundant = false
  geo_backup_enabled = false
  storage_account_type = "Local"
}