variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "policy_name" {
  description = "Nombre de la política de Cloud Armor"
  type        = string
}

variable "description" {
  description = "Descripción de la política"
  type        = string
  default     = ""
}

variable "enable_layer7_ddos_defense" {
  description = "Habilitar defensa contra DDoS de capa 7"
  type        = bool
  default     = true
}

variable "security_rules" {
  description = "Reglas de seguridad"
  type = list(object({
    action      = string          # allow, deny, rate-based-ban, throttle
    priority    = number
    description = string
    match = object({
      versioned_expr = string    # SOC_V2
      expr           = any
    })
    rate_limit = optional(object({
      conform_action = string
      exceed_action  = string
      rate_limit_options = object({
        conform_action             = string
        exceed_action              = string
        enforce_on_key             = string
        requests_per_interval      = number
        interval_sec               = number
      })
    }))
  }))
  default = []
}

variable "labels" {
  description = "Etiquetas para el recurso"
  type        = map(string)
  default     = {}
}
