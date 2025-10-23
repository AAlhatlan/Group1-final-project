# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 🔹 الشبكة
module "network" {
  source              = "./modules/network"
  vnet_name           = "vnet-demo"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 🔹 قاعدة البيانات - Public access + selected networks
module "database" {
  source              = "./modules/database"
  sql_server_name     = "sql-demo-server"
  db_name             = "sqldb-demo"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  admin_username      = var.db_admin_username
  admin_password      = var.db_admin_password
  subnet_id           = module.network.db_subnet_id
}

# 🔹 الكلاستر (نفس السابق)
module "cluster" {
  source              = "./modules/cluster"
  cluster_name        = "aks-group1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.aks_subnet_id
}