output "repository_id" {
  description = "ID del repositorio"
  value       = google_artifact_registry_repository.registry.repository_id
}

output "repository_name" {
  description = "Nombre del repositorio"
  value       = google_artifact_registry_repository.registry.name
}

output "repository_url" {
  description = "URL del repositorio"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.registry.repository_id}"
}

output "repository_location" {
  description = "Ubicación del repositorio"
  value       = google_artifact_registry_repository.registry.location
}

output "repository_format" {
  description = "Formato del repositorio"
  value       = google_artifact_registry_repository.registry.format
}

output "repository_create_time" {
  description = "Fecha de creación del repositorio"
  value       = google_artifact_registry_repository.registry.create_time
}

output "repository_update_time" {
  description = "Fecha de última actualización"
  value       = google_artifact_registry_repository.registry.update_time
}

output "docker_image_pull_command" {
  description = "Comando de ejemplo para hacer pull de una imagen"
  value       = var.repository_format == "DOCKER" ? "docker pull ${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.registry.repository_id}/image:tag" : null
}

output "docker_image_push_command" {
  description = "Comando de ejemplo para hacer push de una imagen"
  value       = var.repository_format == "DOCKER" ? "docker push ${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.registry.repository_id}/image:tag" : null
}
