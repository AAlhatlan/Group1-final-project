variable "prefix" {
  type        = string
  description = "Naming prefix"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for AFD"
}

variable "backend_host_name" {
  type        = string
  description = "Public hostname or IP of AKS ingress (e.g. 68.210.113.93.nip.io)"
}

variable "origin_host_header" {
  type        = string
  description = "Optional host header to send to origin"
  default     = ""
}

variable "health_probe_path" {
  type        = string
  description = "Health probe path"
  default     = "/"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}


