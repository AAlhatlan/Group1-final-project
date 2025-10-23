
data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
}

module "network" {
  source              = "./modules/network"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
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
  sql_admin_login     = var.sql_admin_login
  sql_admin_password  = var.sql_admin_password
}

module "privatelink" {
  source                        = "./modules/privatelink"
  prefix                        = var.prefix
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = module.network.aks_subnet_id
  sql_server_name               = module.sql.sql_server_name
  vnet_id                       = module.network.vnet_id
  sql_server_id                 = module.sql.sql_server_id
}

module "public_ip" {
  source              = "./modules/public_ip"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_managed_disk" "app_disk" {
  name                 = "${var.prefix}-app-disk"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.disk_sku
  disk_size_gb         = var.disk_size_gb
  create_option        = "Empty"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = data.azurerm_kubernetes_cluster.aks.identity[0].principal_id
}
