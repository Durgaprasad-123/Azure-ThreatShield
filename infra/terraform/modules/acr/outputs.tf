output "acr_id" {
  description = "Resource ID of Azure Container Registry"
  value       = azurerm_container_registry.this.id
}

output "acr_login_server" {
  description = "Login server of Azure Container Registry"
  value       = azurerm_container_registry.this.login_server
}