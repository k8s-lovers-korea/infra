data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                = "agentpool"
    vm_size             = var.node_vm_size
    node_count          = var.node_count
    min_count           = var.node_min_count
    max_count           = var.node_max_count
    auto_scaling_enabled= true
    type                = "VirtualMachineScaleSets"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      default_node_pool[0].auto_scaling_enabled,
    ]
  }

  network_profile {
    network_plugin      = "azure" # Azure CNI (recommended for multiple tenants / controlling network)
    network_plugin_mode = "overlay"
    pod_cidr            = var.pod_cidr
  }

  role_based_access_control_enabled = true

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = file(var.ssh_public_key_path)
    }
  }

  # addon_profile {
  #   oms_agent {
  #     enabled                    = true
  #     log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  #   }
  # }

  tags = var.tags
}

# Allow AKS managed identity to pull images from ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
