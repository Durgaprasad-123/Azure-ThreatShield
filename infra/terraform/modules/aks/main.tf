
resource "azurerm_kubernetes_cluster" "this" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  sku_tier           = "Free"
  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name           = "system"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = var.aks_subnet_id

    type = "VirtualMachineScaleSets"
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [var.aks_identity_id]
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"

    pod_cidr       = "192.168.0.0/16"
    service_cidr   = "10.21.0.0/16"
    dns_service_ip = "10.21.0.10"

    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  role_based_access_control_enabled = true
  local_account_disabled            = false

  tags = var.tags
}

