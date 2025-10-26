# إنشاء Azure SQL Server (MSSQL)
resource "azurerm_mssql_server" "main" {
  name                          = "${var.prefix}-sqlsrv"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.sql_admin_username
  administrator_login_password  = var.sql_admin_password
  public_network_access_enabled = true
}

# إنشاء Azure SQL Database (MSSQL)
resource "azurerm_mssql_database" "main" {
  name                 = "${var.prefix}-sqldb"
  server_id            = azurerm_mssql_server.main.id
  sku_name             = "S0"
  storage_account_type = "Local"
}

# Allow AKS subnet via virtual network rule
resource "azurerm_mssql_virtual_network_rule" "aks_allow" {
  name                                 = "${var.prefix}-aks-sql-rule"
  server_id                            = azurerm_mssql_server.main.id
  subnet_id                            = var.aks_subnet_id
  ignore_missing_vnet_service_endpoint = false
}
