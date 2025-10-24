resource "azurerm_container_registry" "main" {
  name                = "${var.prefix}acr"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  admin_enabled       = false

  tags = {
    Environment = "Production"
    Project     = var.prefix
  }
}
