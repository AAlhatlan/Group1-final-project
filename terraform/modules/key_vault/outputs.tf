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

output "secret_ids" {
  description = "Map of Key Vault secret resource IDs keyed by secret name."
  value       = { for name, secret in azurerm_key_vault_secret.this : name => secret.id }
  sensitive   = true
}

output "secret_names" {
  description = "List of Key Vault secret names created by this module."
  value       = keys(azurerm_key_vault_secret.this)
}
