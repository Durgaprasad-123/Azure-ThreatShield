variable "subscription_id" {
  description = "Azure subscription ID for ThreatShield infrastructure"
  type        = string
}

variable "location" {
  description = "Azure region for deploying ThreatShield resources"
  type        = string
  default     = "centralindia"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}