resource "azurerm_resource_group" "threatshield" {
  name     = "rg-threatshield-${var.environment}"
  location = var.location

  tags = {
    project     = "Azure-ThreatShield"
    environment = var.environment
    managed_by  = "terraform"
  }
}

module "vnet" {
  source = "./modules/vnet"

  vnet_name           = "vnet-threatshield-${var.environment}"
  location            = azurerm_resource_group.threatshield.location
  resource_group_name = azurerm_resource_group.threatshield.name

  address_space       = ["10.20.0.0/16"]
  aks_subnet_prefixes = ["10.20.1.0/24"]

  tags = {
    project     = "Azure-ThreatShield"
    environment = var.environment
    managed_by  = "terraform"
  }
}

module "nsg" {
  source = "./modules/nsg"

  nsg_name            = "nsg-threatshield-${var.environment}"
  location            = azurerm_resource_group.threatshield.location
  resource_group_name = azurerm_resource_group.threatshield.name

  tags = {
    project     = "Azure-ThreatShield"
    environment = var.environment
    managed_by  = "terraform"
  }
}

module "acr" {
  source = "./modules/acr"

  acr_name            = "acrthreatshieldprasad26"
  location            = azurerm_resource_group.threatshield.location
  resource_group_name = azurerm_resource_group.threatshield.name

  tags = {
    project     = "Azure-ThreatShield"
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = "id-aks-threatshield-${var.environment}"
  location            = azurerm_resource_group.threatshield.location
  resource_group_name = azurerm_resource_group.threatshield.name

  tags = {
    project     = "Azure-ThreatShield"
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "azurerm_role_assignment" "aks_network" {
  scope                = module.vnet.aks_subnet_id
  role_definition_name = "Network Contributor"

  principal_id = azurerm_user_assigned_identity.aks.principal_id

  skip_service_principal_aad_check = true
}

module "aks" {
  source = "./modules/aks"

  aks_name            = "aks-threatshield-${var.environment}"
  location            = azurerm_resource_group.threatshield.location
  resource_group_name = azurerm_resource_group.threatshield.name

  dns_prefix    = "threatshield-${var.environment}"
  aks_subnet_id = module.vnet.aks_subnet_id

  aks_identity_id = azurerm_user_assigned_identity.aks.id

  kubernetes_version = null
  node_count         = 1
  vm_size            = "Standard_D2s_v3"

  tags = {
    project     = "Azure-ThreatShield"
    environment = var.environment
    managed_by  = "terraform"
  }

  depends_on = [
    azurerm_role_assignment.aks_network
  ]
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"

  principal_id = module.aks.kubelet_identity_object_id

  skip_service_principal_aad_check = true
}
