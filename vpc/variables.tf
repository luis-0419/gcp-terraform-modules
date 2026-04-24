variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string
  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]*[a-z0-9])?$", var.vpc_name))
    error_message = "El nombre de la VPC debe comenzar con una letra minúscula y contener solo letras minúsculas, números y guiones."
  }
}

variable "auto_create_subnetworks" {
  description = "Si se activa, crea automáticamente una subred en cada región. Recomendado: false para mayor control"
  type        = bool
  default     = false
}

variable "routing_mode" {
  description = "Modo de enrutamiento de la VPC: REGIONAL o GLOBAL"
  type        = string
  default     = "REGIONAL"
  validation {
    condition     = contains(["REGIONAL", "GLOBAL"], var.routing_mode)
    error_message = "El routing_mode debe ser REGIONAL o GLOBAL."
  }
}

variable "description" {
  description = "Descripción de la VPC"
  type        = string
  default     = ""
}

variable "enable_flow_logs" {
  description = "Habilitar VPC Flow Logs"
  type        = bool
  default     = false
}

variable "subnets" {
  description = "Lista de subnets a crear"
  type = list(object({
    name            = string
    region          = string
    ip_cidr_range   = string
    secondary_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
    private_ip_google_access = optional(bool, true)
    enable_flow_logs          = optional(bool, false)
  }))
  default = []
  validation {
    condition = length(var.subnets) <= 100
    error_message = "El número máximo de subnets es 100."
  }
}

variable "labels" {
  description = "Etiquetas a aplicar a los recursos"
  type        = map(string)
  default     = {}
}
