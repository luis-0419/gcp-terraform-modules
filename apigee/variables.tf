variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "organization_name" {
  description = "Nombre de la organización Apigee"
  type        = string
}

variable "description" {
  description = "Descripción de la organización"
  type        = string
  default     = ""
}

variable "analytics_region" {
  description = "Región para analytics: us-east1, us-west1, europe-west1, asia-southeast1"
  type        = string
  default     = "us-east1"
}

variable "network_name" {
  description = "Nombre de la VPC (para casos de uso avanzados)"
  type        = string
  default     = null
}

variable "environment_name" {
  description = "Nombre del entorno"
  type        = string
  default     = "prod"
}

variable "environment_description" {
  description = "Descripción del entorno"
  type        = string
  default     = ""
}

variable "environment_type" {
  description = "Tipo de entorno: ENVIRONMENTS_SAMPLE, ENVIRONMENTS_FULL"
  type        = string
  default     = "ENVIRONMENTS_FULL"
}

variable "environment_properties" {
  description = "Propiedades del entorno"
  type        = map(string)
  default     = {}
}

variable "enable_mtls" {
  description = "Habilitar mTLS"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Etiquetas para el recurso"
  type        = map(string)
  default     = {}
}
