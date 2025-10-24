# إنشاء Azure SQL Server (MSSQL)
resource "azurerm_mssql_server" "main" {
  name                         = "${var.prefix}-sqlsrv"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

# إنشاء Azure SQL Database (MSSQL)
resource "azurerm_mssql_database" "main" {
  name      = "${var.prefix}-sqldb"
  server_id = azurerm_mssql_server.main.id
  sku_name  = "S0"
}

# Private Endpoint للـ SQL
resource "azurerm_private_endpoint" "sql" {
  name                = "${var.prefix}-sql-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.prefix}-sql-psc"
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}
