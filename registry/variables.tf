variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "repository_name" {
  description = "Nombre del repositorio de Artifact Registry"
  type        = string
  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]*[a-z0-9])?$", var.repository_name))
    error_message = "El nombre del repositorio debe cumplir con patrones de nombres de GCP"
  }
}

variable "repository_format" {
  description = "Formato del repositorio: DOCKER, NPM, PYTHON, MAVEN, etc."
  type        = string
  default     = "DOCKER"
  validation {
    condition     = contains(["DOCKER", "NPM", "PYTHON", "MAVEN", "APT", "YUM"], var.repository_format)
    error_message = "Formato no válido. Valores permitidos: DOCKER, NPM, PYTHON, MAVEN, APT, YUM"
  }
}

variable "repository_description" {
  description = "Descripción del repositorio"
  type        = string
  default     = ""
}

variable "region" {
  description = "Región donde se crea el repositorio (ej: us-central1, europe-west1)"
  type        = string
  default     = "us-central1"
}

variable "enable_immutable_tags" {
  description = "Habilitar etiquetas inmutables para versiones de imágenes"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Etiquetas para el repositorio"
  type        = map(string)
  default     = {}
}

variable "enable_vulnerability_scanning" {
  description = "Habilitar escaneo de vulnerabilidades en imágenes"
  type        = bool
  default     = true
}

variable "kms_key_name" {
  description = "Clave KMS para encriptación (opcional)"
  type        = string
  default     = null
}
