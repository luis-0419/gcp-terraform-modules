variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "instance_name" {
  description = "Nombre de la instancia de VM"
  type        = string
  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]*[a-z0-9])?$", var.instance_name))
    error_message = "El nombre de la instancia debe comenzar con una letra minúscula y contener solo letras minúsculas, números y guiones."
  }
}

variable "region" {
  description = "Región de GCP"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona de GCP (ej: us-central1-a)"
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "Tipo de máquina (ej: e2-medium, n1-standard-1)"
  type        = string
  default     = "e2-medium"
}

variable "boot_disk_image" {
  description = "Imagen del disco de arranque (ej: debian-cloud/debian-11)"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "boot_disk_size_gb" {
  description = "Tamaño del disco de arranque en GB"
  type        = number
  default     = 20
}

variable "boot_disk_type" {
  description = "Tipo de disco de arranque (pd-standard, pd-balanced, pd-ssd)"
  type        = string
  default     = "pd-standard"
  validation {
    condition     = contains(["pd-standard", "pd-balanced", "pd-ssd"], var.boot_disk_type)
    error_message = "El tipo de disco debe ser pd-standard, pd-balanced o pd-ssd."
  }
}

variable "network_interface" {
  description = "Configuración de interfaz de red"
  type = object({
    network    = string
    subnetwork = string
    assign_public_ip = optional(bool, false)
  })
}

variable "tags" {
  description = "Etiquetas de red para la VM"
  type        = list(string)
  default     = []
}

variable "metadata" {
  description = "Metadatos personalizados para la VM"
  type        = map(string)
  default     = {}
}

variable "service_account_email" {
  description = "Email de la cuenta de servicio a utilizar (opcional)"
  type        = string
  default     = null
}

variable "scopes" {
  description = "Scopes de la cuenta de servicio"
  type        = list(string)
  default     = ["cloud-platform"]
}

variable "labels" {
  description = "Etiquetas a aplicar a los recursos"
  type        = map(string)
  default     = {}
}

variable "preemptible" {
  description = "Si es true, utiliza instancias preemptibles (más económicas pero pueden ser interrumpidas)"
  type        = bool
  default     = false
}

variable "auto_restart" {
  description = "Si es true, reinicia automáticamente la VM si se detiene"
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Si es true, habilita Google Cloud Monitoring"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Si es true, habilita el logging de Google Cloud"
  type        = bool
  default     = true
}

variable "startup_script" {
  description = "Script de inicio a ejecutar cuando la VM se inicia"
  type        = string
  default     = ""
}

variable "shutdown_script" {
  description = "Script a ejecutar cuando la VM se apaga"
  type        = string
  default     = ""
}

variable "additional_disks" {
  description = "Discos adicionales a adjuntar a la VM"
  type = list(object({
    name                      = string
    size_gb                   = number
    type                      = optional(string, "pd-standard")
    interface                 = optional(string, "SCSI")
    mode                      = optional(string, "READ_WRITE")
    delete_on_termination     = optional(bool, true)
  }))
  default = []
}
