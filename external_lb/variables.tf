variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "load_balancer_name" {
  description = "Nombre del load balancer"
  type        = string
}

variable "protocol" {
  description = "Protocolo: HTTP, HTTPS, TCP, UDP"
  type        = string
  default     = "HTTP"
}

variable "port" {
  description = "Puerto"
  type        = number
  default     = 80
}

variable "health_check_port" {
  description = "Puerto para health check"
  type        = number
  default     = 80
}

variable "health_check_interval" {
  description = "Intervalo de health check en segundos"
  type        = number
  default     = 10
}

variable "health_check_timeout" {
  description = "Timeout de health check en segundos"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Número de checks exitosos antes de marcar como healthy"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Número de checks fallidos antes de marcar como unhealthy"
  type        = number
  default     = 2
}

variable "health_check_path" {
  description = "Path del health check"
  type        = string
  default     = "/"
}

variable "session_affinity" {
  description = "Afinidad de sesión: CLIENT_IP, GENERATED_COOKIE, HEADER_FIELD"
  type        = string
  default     = "NONE"
}

variable "timeout_sec" {
  description = "Timeout de conexión en segundos"
  type        = number
  default     = 30
}

variable "network_name" {
  description = "Nombre de la VPC donde están los backends"
  type        = string
  default     = null
}

variable "subnetwork_name" {
  description = "Nombre de la subred (opcional)"
  type        = string
  default     = null
}

variable "labels" {
  description = "Etiquetas para el recurso"
  type        = map(string)
  default     = {}
}

variable "region" {
  type = string
  default = "us-central1"
}