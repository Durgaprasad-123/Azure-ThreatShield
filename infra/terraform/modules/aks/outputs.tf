
output "aks_id" {
  description = "AKS cluster resource ID"
  value       = azurerm_kubernetes_cluster.this.id
}

output "aks_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.this.name
}

output "aks_fqdn" {
  description = "AKS API server FQDN"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "kubelet_identity_object_id" {
  description = "Object ID of the AKS kubelet managed identity"
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

output "kube_config_raw" {
  description = "Kubernetes cluster configuration"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}
