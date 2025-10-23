output "aks_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_identity_principal_id" {
  value = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}