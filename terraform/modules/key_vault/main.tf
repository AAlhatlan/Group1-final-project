locals {
  prefix_hash  = substr(md5(lower(var.prefix)), 0, 12)
  suffix_seed  = var.name_suffix != "" ? lower(var.name_suffix) : "kv"
  suffix_hash  = substr(md5(local.suffix_seed), 0, 12)
  base_name    = substr("${local.prefix_hash}${local.suffix_hash}", 0, 24)
  default_name = length(local.base_name) >= 3 ? local.base_name : "kv${substr(local.prefix_hash, 0, 22)}"

  desired_vault_name = var.key_vault_name != "" ? var.key_vault_name : local.default_name
  key_vault_name     = lower(local.desired_vault_name)
}

resource "azurerm_key_vault" "main" {
  name                            = local.key_vault_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  tenant_id                       = var.tenant_id
  sku_name                        = lower(var.sku_name)
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  public_network_access_enabled   = var.public_network_access_enabled

  tags = var.tags

  dynamic "access_policy" {
    for_each = var.access_policies
    content {
      tenant_id = access_policy.value.tenant_id
      object_id = access_policy.value.object_id

      application_id          = try(access_policy.value.application_id, null)
      certificate_permissions = try(access_policy.value.certificate_permissions, [])
      key_permissions         = try(access_policy.value.key_permissions, [])
      secret_permissions      = try(access_policy.value.secret_permissions, [])
      storage_permissions     = try(access_policy.value.storage_permissions, [])
    }
  }
}
