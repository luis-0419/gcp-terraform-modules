output "instance_name" {
  description = "Nombre de la instancia Cloud SQL"
  value       = google_sql_database_instance.instance.name
}

output "instance_connection_name" {
  description = "Connection string de Cloud SQL"
  value       = google_sql_database_instance.instance.connection_name
}

output "database_version" {
  description = "Versión de la base de datos"
  value       = google_sql_database_instance.instance.database_version
}

output "private_ip_address" {
  description = "Dirección IP privada"
  value       = try(google_sql_database_instance.instance.private_ip_address, null)
}

output "public_ip_address" {
  description = "Dirección IP pública"
  value       = try(google_sql_database_instance.instance.public_ip_address, null)
}

output "database_name" {
  description = "Nombre de la base de datos"
  value       = google_sql_database.databases.name
}
