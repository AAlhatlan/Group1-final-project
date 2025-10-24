output "acr_login_server" {
  description = "Login server of ACR"
  value       = azurerm_container_registry.main.login_server
}

output "acr_id" {
  description = "ID of the ACR"
  value       = azurerm_container_registry.main.id
}
