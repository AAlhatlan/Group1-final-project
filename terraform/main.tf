module "networking" {
  source              = "./modules/networking"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  vnet_address_space  = var.vnet_address_space
}

module "aks" {
  source              = "./modules/aks"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  node_count          = var.aks_node_count
  vm_size             = var.aks_vm_size
  min_count           = var.aks_min_count
  max_count           = var.aks_max_count
  subnet_id           = module.networking.aks_subnet_id
}

module "acr" {
  source              = "./modules/acr"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "sql" {
  source              = "./modules/sql"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  sql_admin_username  = var.sql_admin
  sql_admin_password  = var.sql_password
  subnet_id           = module.networking.aks_subnet_id
}

module "keyvault" {
  source                  = "./modules/KeyVault"
  prefix                  = var.prefix
  location                = var.location
  resource_group_name     = var.resource_group_name
  aks_managed_identity_id = module.aks.aks_identity_id
}
