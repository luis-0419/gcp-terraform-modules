variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "service_connection_name" {
  description = "Nombre de la conexión de servicio privado"
  type        = string
}

variable "network_id" {
  description = "ID de la red VPC"
  type        = string
}

variable "service_name" {
  description = "Nombre del servicio: compute, storage, bigquery, etc."
  type        = string
  default     = "compute"
}

variable "reserved_ip_range" {
  description = "Rango de IP reservado para la conexión PSC"
  type        = string
}

variable "enable_dns_name_resolution" {
  description = "Habilitar resolución de nombre DNS"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Etiquetas para el recurso"
  type        = map(string)
  default     = {}
}

variable "subnetwork_id" {
  description = "ID de la subred (opcional)"
  type        = string
  default     = null
  
}
