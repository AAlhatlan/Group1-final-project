locals {
  prefix_hash  = substr(md5(lower(var.prefix)), 0, 12)
  suffix_seed  = var.name_suffix != "" ? lower(var.name_suffix) : "storage"
  suffix_hash  = substr(md5(local.suffix_seed), 0, 12)
  base_name    = substr("${local.prefix_hash}${local.suffix_hash}", 0, 24)
  default_name = length(local.base_name) >= 3 ? local.base_name : "stg${substr(local.prefix_hash, 0, 21)}"

  storage_account_name = var.storage_account_name != "" ? var.storage_account_name : local.default_name
}

resource "azurerm_storage_account" "main" {
  name                            = local.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  access_tier                     = var.access_tier
  min_tls_version                 = var.min_tls_version
  account_kind                    = var.account_kind
  https_traffic_only_enabled      = var.https_traffic_only_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public

  tags = var.tags
}
