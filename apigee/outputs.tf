output "organization_id" {
  description = "ID de la organización Apigee"
  value       = google_apigee_organization.organization.id
}

output "organization_name" {
  description = "Nombre de la organización"
  value       = google_apigee_organization.organization.display_name
}

output "environment_id" {
  description = "ID del entorno"
  value       = google_apigee_environment.environment.id
}

output "environment_name" {
  description = "Nombre del entorno"
  value       = google_apigee_environment.environment.name
}

output "envgroup_id" {
  description = "ID del environment group"
  value       = google_apigee_envgroup.envgroup.id
}

output "envgroup_hostnames" {
  description = "Hostnames del environment group"
  value       = google_apigee_envgroup.envgroup.hostnames
}
