locals {
  sanitized_prefix = lower(regexreplace(var.prefix, "[^a-z0-9]", ""))
  sanitized_suffix = lower(regexreplace(var.name_suffix, "[^a-z0-9]", ""))
  base_name        = "${local.sanitized_prefix}${local.sanitized_suffix != "" ? local.sanitized_suffix : "storage"}"
  trimmed_name     = substr(local.base_name, 0, 24)
  default_name     = length(local.trimmed_name) >= 3 ? local.trimmed_name : "stg${substr(local.sanitized_prefix, 0, 20)}"

  storage_account_name = var.storage_account_name != "" ? var.storage_account_name : local.default_name
}

resource "azurerm_storage_account" "main" {
  name                     = local.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier
  min_tls_version          = var.min_tls_version
  allow_blob_public_access = var.allow_blob_public_access
  enable_https_traffic_only = var.enable_https_traffic_only
  kind                     = var.kind

  tags = var.tags
}
