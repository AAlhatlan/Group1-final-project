locals {
  deploy_prefix       = var.prefix
  effective_rg_name   = var.resource_group_name != "" ? var.resource_group_name : "rg-${local.deploy_prefix}"
  effective_location  = var.location
  node_pool_temp_name = substr(replace(local.deploy_prefix, "-", ""), 0, 9)
  aks_uami_name       = "${local.deploy_prefix}-aks-uami"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = local.effective_rg_name
  location = local.effective_location
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = local.aks_uami_name
  location            = local.effective_location
  resource_group_name = azurerm_resource_group.main.name
}

module "storage_account" {
  source              = "./modules/storage_account"
  prefix              = local.deploy_prefix
  location            = local.effective_location
  resource_group_name = azurerm_resource_group.main.name
}

module "networking" {
  source              = "./modules/networking"
  prefix              = local.deploy_prefix
  location            = local.effective_location
  resource_group_name = azurerm_resource_group.main.name
  vnet_address_space  = var.vnet_address_space
}

module "aks" {
  source                       = "./modules/aks"
  prefix                       = local.deploy_prefix
  location                     = local.effective_location
  resource_group_name          = azurerm_resource_group.main.name
  node_count                   = var.aks_node_count
  vm_size                      = var.aks_vm_size
  min_count                    = var.aks_min_count
  max_count                    = var.aks_max_count
  subnet_id                    = module.networking.aks_subnet_id
  temp_node_pool_name          = "${local.node_pool_temp_name}tp"
  userpool_temp_node_pool_name = "${local.node_pool_temp_name}up"
  user_assigned_identity_id    = azurerm_user_assigned_identity.aks.id
}

module "sql" {
  source              = "./modules/sql"
  prefix              = local.deploy_prefix
  location            = local.effective_location
  resource_group_name = azurerm_resource_group.main.name
  sql_admin_username  = var.sql_admin
  sql_admin_password  = var.sql_password
  aks_subnet_id       = module.networking.aks_subnet_id
}

module "key_vault" {
  source                          = "./modules/key_vault"
  prefix                          = local.deploy_prefix
  location                        = local.effective_location
  resource_group_name             = azurerm_resource_group.main.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  key_vault_name                  = var.key_vault_name
  name_suffix                     = var.key_vault_name_suffix
  sku_name                        = var.key_vault_sku_name
  soft_delete_retention_days      = var.key_vault_soft_delete_retention_days
  purge_protection_enabled        = var.key_vault_purge_protection_enabled
  enabled_for_disk_encryption     = var.key_vault_enabled_for_disk_encryption
  enabled_for_deployment          = var.key_vault_enabled_for_deployment
  enabled_for_template_deployment = var.key_vault_enabled_for_template_deployment
  public_network_access_enabled   = var.key_vault_public_network_access_enabled
  access_policies = concat(
    var.key_vault_access_policies,
    [
      {
        tenant_id               = data.azurerm_client_config.current.tenant_id
        object_id               = data.azurerm_client_config.current.object_id
        certificate_permissions = []
        key_permissions         = []
        secret_permissions      = ["Get", "List", "Set", "Delete"]
        storage_permissions     = []
      },
      {
        tenant_id               = data.azurerm_client_config.current.tenant_id
        object_id               = module.aks.aks_identity_id
        certificate_permissions = []
        key_permissions         = []
        secret_permissions      = ["Get", "List"]
        storage_permissions     = []
      },
      {
        tenant_id               = data.azurerm_client_config.current.tenant_id
        object_id               = azurerm_user_assigned_identity.aks.principal_id
        certificate_permissions = []
        key_permissions         = []
        secret_permissions      = ["Get", "List"]
        storage_permissions     = []
      }
    ]
  )
  secrets = {
    "sql-admin-username" = {
      value        = var.sql_admin
      content_type = "text/plain"
    }
    "sql-admin-password" = {
      value        = var.sql_password
      content_type = "text/plain"
    }
  }
  tags = var.key_vault_tags
}
