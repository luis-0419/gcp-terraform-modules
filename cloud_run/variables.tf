variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "service_name" {
  description = "Nombre del servicio Cloud Run"
  type        = string
}

variable "region" {
  description = "Región de GCP"
  type        = string
  default     = "us-central1"
}

variable "image" {
  description = "URL de la imagen Docker"
  type        = string
}

variable "memory" {
  description = "Memoria asignada en MB"
  type        = string
  default     = "256Mi"
}

variable "cpu" {
  description = "CPU asignada"
  type        = string
  default     = "1"
}

variable "timeout_seconds" {
  description = "Timeout de solicitud en segundos"
  type        = number
  default     = 300
}

variable "min_instances" {
  description = "Instancias mínimas"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Instancias máximas"
  type        = number
  default     = 100
}

variable "environment_variables" {
  description = "Variables de entorno"
  type        = map(string)
  default     = {}
}

variable "secret_environment_variables" {
  description = "Variables de entorno secretas"
  type        = map(object({
    key         = string
    secret_name = string
    version     = string
  }))
  default = {}
}

variable "allow_public_access" {
  description = "Permitir acceso público"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Etiquetas para el recurso"
  type        = map(string)
  default     = {}
}
