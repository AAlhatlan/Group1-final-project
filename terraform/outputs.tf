output "aks_name" {
  description = "AKS cluster name"
  value       = module.aks.aks_name
}

output "sql_fqdn" {
  description = "SQL fully qualified domain name"
  value       = module.sql.sql_fqdn
}

output "keyvault_uri" {
  description = "Key Vault URI"
  value       = module.keyvault.key_vault_uri
}

output "storage_account_name" {
  description = "Storage account name"
  value       = module.storage_account.storage_account_name
}

output "storage_primary_blob_endpoint" {
  description = "Primary blob endpoint for the storage account"
  value       = module.storage_account.primary_blob_endpoint
}

output "storage_primary_connection_string" {
  description = "Primary connection string for the storage account"
  value       = module.storage_account.primary_connection_string
  sensitive   = true
}
