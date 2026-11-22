variable "vnet_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
variable "aks_subnet_prefixes" {
  description = "IP address ranges for the AKS subnet"
  type        = list(string)
}