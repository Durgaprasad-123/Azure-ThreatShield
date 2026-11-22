output "nsg_id" {
  description = "Azure Network Security Group resource ID"
  value       = azurerm_network_security_group.this.id
}