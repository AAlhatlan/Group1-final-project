resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "storage_account" {
  source              = "./modules/storage_account"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

module "networking" {
  source              = "./modules/networking"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  vnet_address_space  = var.vnet_address_space
}

module "aks" {
  source              = "./modules/aks"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  node_count          = var.aks_node_count
  vm_size             = var.aks_vm_size
  min_count           = var.aks_min_count
  max_count           = var.aks_max_count
  subnet_id           = module.networking.aks_subnet_id
}

module "sql" {
  source              = "./modules/sql"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sql_admin_username  = var.sql_admin
  sql_admin_password  = var.sql_password
  subnet_id           = module.networking.aks_subnet_id
}

module "keyvault" {
  source                  = "./modules/KeyVault"
  prefix                  = var.prefix
  location                = var.location
  resource_group_name     = azurerm_resource_group.main.name
  aks_managed_identity_id = module.aks.aks_identity_id
}
