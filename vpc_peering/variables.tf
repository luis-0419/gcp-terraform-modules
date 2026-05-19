variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "local_network_name" {
  description = "Nombre de la red local (VPC origen del peering)"
  type        = string
  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]*[a-z0-9])?$", var.local_network_name))
    error_message = "El nombre de la red local debe comenzar con una letra minúscula y contener solo letras minúsculas, números y guiones."
  }
}

variable "peer_project_id" {
  description = "ID del proyecto de GCP del peer (puede ser el mismo proyecto)"
  type        = string
}

variable "peer_network_name" {
  description = "Nombre de la red peer (VPC destino del peering)"
  type        = string
  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]*[a-z0-9])?$", var.peer_network_name))
    error_message = "El nombre de la red peer debe comenzar con una letra minúscula y contener solo letras minúsculas, números y guiones."
  }
}

variable "peering_name" {
  description = "Nombre de la conexión de peering"
  type        = string
  default     = null
  validation {
    condition     = var.peering_name == null || can(regex("^[a-z]([a-z0-9-]*[a-z0-9])?$", var.peering_name))
    error_message = "El nombre del peering debe comenzar con una letra minúscula y contener solo letras minúsculas, números y guiones."
  }
}

variable "auto_create_routes" {
  description = "Si es true, las rutas entre los peers se crean automáticamente"
  type        = bool
  default     = true
}

variable "export_custom_routes" {
  description = "Si es true, las rutas personalizadas de la red local se exportan a la red peer"
  type        = bool
  default     = false
}

variable "import_custom_routes" {
  description = "Si es true, las rutas personalizadas de la red peer se importan a la red local"
  type        = bool
  default     = false
}

variable "export_subnet_routes_with_public_ip" {
  description = "Si es true, las subredes con IPs públicas se exportan al peer"
  type        = bool
  default     = false
}

variable "import_subnet_routes_with_public_ip" {
  description = "Si es true, las subredes con IPs públicas del peer se importan"
  type        = bool
  default     = false
}

variable "create_reverse_peering" {
  description = "Si es true, se crea el peering inverso (desde peer hacia local)"
  type        = bool
  default     = true
}

variable "reverse_peering_name" {
  description = "Nombre del peering inverso (opcional, se genera automáticamente si es null)"
  type        = string
  default     = null
  validation {
    condition     = var.reverse_peering_name == null || can(regex("^[a-z]([a-z0-9-]*[a-z0-9])?$", var.reverse_peering_name))
    error_message = "El nombre del peering inverso debe comenzar con una letra minúscula y contener solo letras minúsculas, números y guiones."
  }
}

variable "labels" {
  description = "Etiquetas a aplicar a los recursos"
  type        = map(string)
  default     = {}
}
