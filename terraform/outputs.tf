output "aks_name" {
  description = "AKS cluster name"
  value       = module.aks.aks_name
}

output "acr_login_server" {
  description = "ACR login server"
  value       = module.acr.acr_login_server
}

output "sql_fqdn" {
  description = "SQL fully qualified domain name"
  value       = module.sql.sql_fqdn
}

output "keyvault_uri" {
  description = "Key Vault URI"
  value       = module.keyvault.key_vault_uri
}
