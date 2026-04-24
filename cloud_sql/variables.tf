variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "instance_name" {
  description = "Nombre de la instancia Cloud SQL"
  type        = string
}

variable "database_version" {
  description = "Versión de base de datos: MYSQL_8_0, POSTGRES_15, SQLSERVER_2019"
  type        = string
  default     = "POSTGRES_15"
}

variable "region" {
  description = "Región de GCP"
  type        = string
  default     = "us-central1"
}

variable "tier" {
  description = "Tier de la instancia (ej: db-f1-micro, db-g1-small)"
  type        = string
  default     = "db-f1-micro"
}

variable "availability_type" {
  description = "Tipo de disponibilidad: REGIONAL o ZONAL"
  type        = string
  default     = "REGIONAL"
}

variable "disk_size" {
  description = "Tamaño del disco en GB"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Tipo de disco: PD_SSD o PD_HDD"
  type        = string
  default     = "PD_SSD"
}

variable "enable_public_ip" {
  description = "Asignar IP pública"
  type        = bool
  default     = false
}

variable "private_network" {
  description = "ID de la red VPC para Private IP"
  type        = string
  default     = null
}

variable "backup_enabled" {
  description = "Habilitar backups automáticos"
  type        = bool
  default     = true
}

variable "backup_start_time" {
  description = "Hora del backup en formato HH:MM"
  type        = string
  default     = "03:00"
}

variable "database_name" {
  description = "Nombre de la base de datos inicial"
  type        = string
  default     = "main"
}

variable "username" {
  description = "Usuario root"
  type        = string
  default     = "root"
}

variable "user_password" {
  description = "Contraseña del usuario root"
  type        = string
  sensitive   = true
  default     = null
}

variable "labels" {
  description = "Etiquetas para el recurso"
  type        = map(string)
  default     = {}
}
