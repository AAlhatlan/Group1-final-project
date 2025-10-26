output "key_vault_id" {
  description = "Key Vault resource ID"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Key Vault name"
  value       = azurerm_key_vault.main.name
}

output "sql_admin_username_secret_id" {
  description = "Secret ID storing the SQL admin username"
  value       = azurerm_key_vault_secret.sql_admin_username.id
}

output "sql_admin_password_secret_id" {
  description = "Secret ID storing the SQL admin password"
  value       = azurerm_key_vault_secret.sql_admin_password.id
}
