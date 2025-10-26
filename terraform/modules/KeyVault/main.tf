data "azurerm_client_config" "current" {}

# إنشاء Key Vault
resource "azurerm_key_vault" "main" {
  name                     = lower("${var.prefix}-kv")
  location                 = var.location
  resource_group_name      = var.resource_group_name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true

}

# Store SQL admin credentials
resource "azurerm_key_vault_secret" "sql_admin_username" {
  name         = "sql-admin-username"
  value        = var.sql_admin_username
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = var.sql_admin_password
  key_vault_id = azurerm_key_vault.main.id
}

# منح AKS Managed Identity صلاحية الوصول للـ KV
resource "azurerm_key_vault_access_policy" "aks" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.aks_managed_identity_id

  secret_permissions = [
    "Get",
    "List"
  ]
}
