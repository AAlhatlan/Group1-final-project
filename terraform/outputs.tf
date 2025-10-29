output "aks_name" {
  description = "AKS cluster name"
  value       = module.aks.aks_name
}

output "sql_fqdn" {
  description = "SQL fully qualified domain name"
  value       = module.sql.sql_fqdn
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

output "aks_identity_client_id" {
  description = "Client ID of the AKS kubelet managed identity"
  value       = module.aks.aks_identity_client_id
}

output "aks_kube_config" {
  description = "Raw kubeconfig for the AKS cluster"
  value       = module.aks.aks_kube_config
  sensitive   = true
}

output "aks_node_resource_group" {
  description = "Node resource group created for AKS"
  value       = module.aks.aks_resource_group
}

output "aks_user_assigned_identity_client_id" {
  description = "Client ID of the user assigned managed identity attached to AKS"
  value       = azurerm_user_assigned_identity.aks.client_id
}

output "aks_user_assigned_identity_principal_id" {
  description = "Principal ID of the user assigned managed identity attached to AKS"
  value       = azurerm_user_assigned_identity.aks.principal_id
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault"
  value       = module.key_vault.key_vault_id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.key_vault_name
}

output "key_vault_uri" {
  description = "Vault URI endpoint for secrets"
  value       = module.key_vault.key_vault_uri
}

output "key_vault_secret_ids" {
  description = "Key Vault secret resource IDs keyed by secret name"
  value       = module.key_vault.secret_ids
  sensitive   = true
}

output "key_vault_secret_names" {
  description = "Names of Key Vault secrets created by Terraform"
  value       = module.key_vault.secret_names
}

output "tenant_id" {
  description = "Azure AD tenant ID used for the deployment"
  value       = data.azurerm_client_config.current.tenant_id
}

output "ingress_static_ip" {
  description = "Static Public IP for Ingress"
  value       = azurerm_public_ip.ingress.ip_address
}

output "frontdoor_endpoint" {
  description = "Azure Front Door endpoint (azurefd.net)"
  value       = try(module.frontdoor[0].frontdoor_endpoint_hostname, null)
}
