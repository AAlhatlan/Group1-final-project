resource "azurerm_private_endpoint" "sql_pe" {
  name                = "${var.prefix}-sql-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.prefix}-sql-psc"
    private_connection_resource_id = var.sql_server_id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_dns_link" {
  name                  = "${var.prefix}-sql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql_dns.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}
resource "azurerm_private_dns_zone" "sql_dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
}