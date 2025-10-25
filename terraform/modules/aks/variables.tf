variable "prefix" {
  description = "Prefix for resources"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "node_count" {
  description = "Default number of nodes"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for nodes"
  type        = string
  default     = "Standard_E2bds_v5"
}

variable "min_count" {
  description = "Minimum nodes for autoscaler"
  type        = number
  default     = 2
}

variable "max_count" {
  description = "Maximum nodes for autoscaler"
  type        = number
  default     = 5
}

variable "subnet_id" {
  description = "Subnet ID where AKS will be deployed"
  type        = string
}

variable "service_cidr" {
  description = "Kubernetes service CIDR"
  type        = string
  default     = "10.2.0.0/16"
}

variable "dns_service_ip" {
  description = "Kubernetes DNS service IP"
  type        = string
  default     = "10.2.0.10"
}

variable "userpool_min_count" {
  description = "Minimum nodes for user node pool autoscaling"
  type        = number
  default     = 2
}

variable "userpool_max_count" {
  description = "Maximum nodes for user node pool autoscaling"
  type        = number
  default     = 5
}
