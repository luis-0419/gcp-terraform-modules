variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "bucket_name" {
  description = "Nombre del bucket"
  type        = string
}

variable "location" {
  description = "Ubicación del bucket (región o multi-región)"
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "Clase de almacenamiento: STANDARD, NEARLINE, COLDLINE, ARCHIVE"
  type        = string
  default     = "STANDARD"
}

variable "uniform_bucket_level_access" {
  description = "Habilitar acceso uniforme a nivel de bucket"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Habilitar encriptación CMEK"
  type        = bool
  default     = false
}

variable "kms_key_name" {
  description = "KMS key para encriptación CMEK"
  type        = string
  default     = null
}

variable "versioning_enabled" {
  description = "Habilitar versionado de objetos"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "Reglas de ciclo de vida"
  type = list(object({
    action          = string  # Delete, SetStorageClass
    storage_class   = optional(string)
    age_days        = optional(number)
    num_newer_versions = optional(number)
  }))
  default = []
}

variable "cors_enabled" {
  description = "Habilitar CORS"
  type        = bool
  default     = false
}

variable "cors_origins" {
  description = "Orígenes permitidos para CORS"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Etiquetas para el recurso"
  type        = map(string)
  default     = {}
}
