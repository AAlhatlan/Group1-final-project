terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = "${var.prefix}-afd-profile"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = var.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "this" {
  name                     = "${var.prefix}-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 4
    successful_samples_required       = 3
  }

  health_probe {
    interval_in_seconds = 30
    path                = var.health_probe_path
    protocol            = "Http"
    request_type        = "GET"
  }
}

resource "azurerm_cdn_frontdoor_origin" "this" {
  name                          = "${var.prefix}-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this.id

  host_name                      = var.backend_host_name
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.origin_host_header != "" ? var.origin_host_header : var.backend_host_name
  priority                       = 1
  weight                         = 1000
  enabled                        = true
  certificate_name_check_enabled = false
}

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  name                     = "${var.prefix}-afd-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  enabled                  = true
  tags                     = var.tags
}

resource "azurerm_cdn_frontdoor_route" "this" {
  name                          = "${var.prefix}-route-all"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.this.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this.id
  cdn_frontdoor_origin_ids     = [azurerm_cdn_frontdoor_origin.this.id]

  supported_protocols   = ["Http", "Https"]
  https_redirect_enabled = true

  forwarding_protocol = "HttpOnly"
  patterns_to_match   = ["/*"]
  enabled             = true
}

