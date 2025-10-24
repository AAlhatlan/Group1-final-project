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
