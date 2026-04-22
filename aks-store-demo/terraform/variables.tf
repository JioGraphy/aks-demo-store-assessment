variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "aks-store-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
  default     = "aks-store-cluster"
}

variable "acr_name" {
  description = "Azure Container Registry name"
  type        = string
  default     = "aksstoredemoregistry"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "system_node_count" {
  description = "Node count for system node pool"
  type        = number
  default     = 2
}

variable "system_vm_size" {
  description = "VM size for system node pool"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "app_node_count" {
  description = "Node count for application node pool"
  type        = number
  default     = 2
}

variable "app_vm_size" {
  description = "VM size for application node pool"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "aks-store-demo"
    ManagedBy = "Terraform"
  }
}