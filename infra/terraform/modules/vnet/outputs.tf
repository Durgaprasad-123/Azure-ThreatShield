output "vnet_id" {
  description = "Azure Virtual Network resource ID"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Azure Virtual Network name"
  value       = azurerm_virtual_network.this.name
}
output "aks_subnet_id" {
  description = "Resource ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}