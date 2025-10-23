# 🧱 Azure SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.admin_username
  administrator_login_password  = var.admin_password

  # ✅ نخلي السيرفر يستخدم "Selected Networks"
  public_network_access_enabled = true
  minimum_tls_version           = "1.2"
}

# 🗄️ Azure SQL Database
resource "azurerm_mssql_database" "sql_db" {
  name        = var.db_name
  server_id   = azurerm_mssql_server.sql_server.id
  sku_name    = "S0"
  max_size_gb = 10
}

# 🔒 نربط الـVNet/Subnet كـ Virtual Network Rule (يعني access فقط منها)
resource "azurerm_mssql_virtual_network_rule" "vnet_rule" {
  name      = "allow-vnet-access"
  server_id = azurerm_mssql_server.sql_server.id
  subnet_id = var.subnet_id

  # هذي تخلي السيرفر يسمح بالاتصال من السبنت فقط
  depends_on = [var.subnet_id]
}

# 🚫 نمنع أي اتصال عام (مثل Allow Azure services) بإلغاء القاعدة الافتراضية
# تقدر تضيف firewall rule محددة إذا حبيت لاحقًا.