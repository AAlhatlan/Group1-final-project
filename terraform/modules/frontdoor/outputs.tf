output "frontdoor_endpoint_hostname" {
  value       = azurerm_cdn_frontdoor_endpoint.this.host_name
  description = "Azure Front Door endpoint hostname (*.azurefd.net)"
}

