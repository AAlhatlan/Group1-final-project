data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

# إنشاء Key Vault
resource "azurerm_key_vault" "main" {
  name                     = "${var.prefix}-${random_string.suffix.result}-kv2"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true

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
