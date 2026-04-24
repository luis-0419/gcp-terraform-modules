variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "region" {
  description = "Región de GCP por defecto"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Ambiente: dev, staging, prod"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment debe ser: dev, staging, o prod"
  }
}
