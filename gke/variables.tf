variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "cluster_name" {
  description = "Nombre del cluster de GKE"
  type        = string
  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]*[a-z0-9])?$", var.cluster_name))
    error_message = "El nombre del cluster debe cumplir con patrones de nombres de GCP"
  }
}

variable "location" {
  description = "Zona o región del cluster"
  type        = string
}

variable "network_name" {
  description = "Nombre de la red VPC"
  type        = string
}

variable "subnetwork_name" {
  description = "Nombre de la subred"
  type        = string
}

variable "initial_node_count" {
  description = "Número inicial de nodos"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Tipo de máquina para los nodos"
  type        = string
  default     = "n1-standard-1"
}

variable "preemptible_nodes" {
  description = "Usar nodos preemptibles (más económicos)"
  type        = bool
  default     = true
}

variable "enable_autoscaling" {
  description = "Habilitar autoscaling de nodos"
  type        = bool
  default     = true
}

variable "min_node_count" {
  description = "Número mínimo de nodos en autoscaling"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Número máximo de nodos en autoscaling"
  type        = number
  default     = 10
}

variable "enable_shielded_nodes" {
  description = "Habilitar Shielded GKE Nodes"
  type        = bool
  default     = true
}

variable "enable_ip_alias" {
  description = "Usar IP alias de VPC"
  type        = bool
  default     = true
}

variable "cluster_secondary_range_name" {
  description = "Nombre del rango secundario para pods (dejarlo vacío para auto-generar CIDR)"
  type        = string
  default     = ""
}

variable "services_secondary_range_name" {
  description = "Nombre del rango secundario para servicios (dejarlo vacío para auto-generar CIDR)"
  type        = string
  default     = ""
}

variable "cluster_ipv4_cidr_block" {
  description = "CIDR block automático para pods (ej: 10.4.0.0/14). Se usa si no hay nombre de rango secundario"
  type        = string
  default     = "10.4.0.0/14"
}

variable "services_ipv4_cidr_block" {
  description = "CIDR block automático para servicios (ej: 10.0.0.0/20). Se usa si no hay nombre de rango secundario"
  type        = string
  default     = "10.0.0.0/20"
}

variable "release_channel" {
  description = "Canal de lanzamiento: UNSPECIFIED, RAPID, REGULAR, STABLE"
  type        = string
  default     = "REGULAR"
}

variable "enable_network_policy" {
  description = "Habilitar Network Policy"
  type        = bool
  default     = true
}

variable "enable_log_sink" {
  description = "Habilitar logging de cluster"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Etiquetas para el cluster"
  type        = map(string)
  default     = {}
}
