output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

output "sql_subnet_id" {
  description = "ID of the SQL subnet"
  value       = azurerm_subnet.sql.id
}

output "vnet_id" {
  description = "ID of the VNet"
  value       = azurerm_virtual_network.main.id
}
