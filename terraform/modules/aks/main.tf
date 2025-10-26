# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.prefix}-law"
  location            = "westeurope"      
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# AKS Cluster الأساسي
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.prefix}-dns"

  default_node_pool {
    name                        = "default"
    node_count                  = var.node_count
    vm_size                     = var.vm_size
    vnet_subnet_id              = var.subnet_id
    temporary_name_for_rotation = var.temp_node_pool_name
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
  }

  tags = {
    Environment = "Production"
    Project     = var.prefix
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D2s_v3"
  auto_scaling_enabled  = true
  min_count             = var.userpool_min_count
  max_count             = var.userpool_max_count
  mode                  = "User"
  temporary_name_for_rotation = var.userpool_temp_node_pool_name
}

