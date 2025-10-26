locals {
  deploy_prefix       = var.prefix
  effective_rg_name   = var.resource_group_name != "" ? var.resource_group_name : "rg-${local.deploy_prefix}"
  effective_location  = var.location
  node_pool_temp_name = substr(replace(local.deploy_prefix, "-", ""), 0, 9)
}

resource "azurerm_resource_group" "main" {
  name     = local.effective_rg_name
  location = local.effective_location
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
  source              = "./modules/aks"
  prefix              = local.deploy_prefix
  location            = local.effective_location
  resource_group_name = azurerm_resource_group.main.name
  node_count          = var.aks_node_count
  vm_size             = var.aks_vm_size
  min_count           = var.aks_min_count
  max_count           = var.aks_max_count
  subnet_id           = module.networking.aks_subnet_id
  temp_node_pool_name = "${local.node_pool_temp_name}tp"
  userpool_temp_node_pool_name = "${local.node_pool_temp_name}up"
}

module "sql" {
  source              = "./modules/sql"
  prefix              = local.deploy_prefix
  location            = local.effective_location
  resource_group_name = azurerm_resource_group.main.name
  sql_admin_username  = var.sql_admin
  sql_admin_password  = var.sql_password
  subnet_id           = module.networking.sql_subnet_id
  vnet_id             = module.networking.vnet_id
}

module "keyvault" {
  source                  = "./modules/KeyVault"
  prefix                  = local.deploy_prefix
  location                = local.effective_location
  resource_group_name     = azurerm_resource_group.main.name
  aks_managed_identity_id = module.aks.aks_identity_id
}
