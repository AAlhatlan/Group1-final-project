# إنشاء Azure SQL Server (MSSQL)
resource "azurerm_mssql_server" "main" {
  name                          = "${var.prefix}-sqlsrv"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.sql_admin_username
  administrator_login_password  = var.sql_admin_password
  public_network_access_enabled = false
}

# إنشاء Azure SQL Database (MSSQL)
resource "azurerm_mssql_database" "main" {
  name                 = "${var.prefix}-sqldb"
  server_id            = azurerm_mssql_server.main.id
  sku_name             = "S0"
  storage_account_type = "Local"
}

# Private DNS zone for SQL private endpoint
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "${var.prefix}-sql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = var.vnet_id
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

  private_dns_zone_group {
    name                 = "${var.prefix}-sql-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }
}
