variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "router_name" {
  description = "Nombre del router"
  type        = string
}

variable "region" {
  description = "Región de GCP"
  type        = string
}

variable "network_name" {
  description = "Nombre de la VPC"
  type        = string
}

variable "nat_name" {
  description = "Nombre del NAT"
  type        = string
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "Rangos de subnetwork: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS"
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "nat_ip_allocate_option" {
  description = "Opción de asignación: AUTO_ONLY, MANUAL_ONLY"
  type        = string
  default     = "AUTO_ONLY"
}

variable "nat_ips" {
  description = "IPs estáticas para NAT (si nat_ip_allocate_option es MANUAL_ONLY)"
  type        = list(string)
  default     = []
}

variable "subnetworks" {
  description = "Subredes específicas (si source_subnetwork_ip_ranges_to_nat es LIST_OF_SUBNETWORKS)"
  type        = list(string)
  default     = []
}

variable "enable_logging" {
  description = "Habilitar logging del NAT"
  type        = bool
  default     = true
}

variable "log_filter" {
  description = "Filtro de logging: ALL, ERRORS_ONLY, TRANSLATIONS_ONLY"
  type        = string
  default     = "ERRORS_ONLY"
}

variable "tcp_established_idle_timeout_sec" {
  description = "Timeout para conexiones TCP establecidas (segundos)"
  type        = number
  default     = 1200
}

variable "tcp_transitory_idle_timeout_sec" {
  description = "Timeout para conexiones TCP transitorias (segundos)"
  type        = number
  default     = 30
}

variable "udp_idle_timeout_sec" {
  description = "Timeout para conexiones UDP (segundos)"
  type        = number
  default     = 30
}
