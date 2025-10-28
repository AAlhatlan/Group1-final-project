output "key_vault_id" {
  description = "Resource ID of the key vault."
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the key vault."
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "Vault URI for accessing secrets."
  value       = azurerm_key_vault.main.vault_uri
}
