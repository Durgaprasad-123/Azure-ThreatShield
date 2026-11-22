
variable "aks_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region for AKS"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group containing AKS"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS API endpoint"
  type        = string
}

variable "aks_subnet_id" {
  description = "Subnet resource ID for AKS nodes"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version; null selects the Azure default"
  type        = string
  default     = null
}

variable "node_count" {
  description = "Number of nodes in the system node pool"
  type        = number
  default     = 1

  validation {
    condition     = var.node_count >= 1
    error_message = "The node count must be at least 1."
  }
}

variable "vm_size" {
  description = "Azure VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "tags" {
  description = "Tags applied to the AKS cluster"
  type        = map(string)
  default     = {}
}
variable "aks_identity_id" {
  description = "User-assigned managed identity resource ID for AKS"
  type        = string
}