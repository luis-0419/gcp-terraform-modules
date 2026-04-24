output "kubernetes_cluster_name" {
  description = "Nombre del cluster de GKE"
  value       = google_container_cluster.primary.name
}

output "kubernetes_cluster_host" {
  description = "Endpoint del cluster"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "region" {
  description = "Región/Zona del cluster"
  value       = var.location
}

output "project_id" {
  description = "ID del project"
  value       = var.project_id
}

output "ca_certificate" {
  description = "Certificado CA del cluster"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "client_token" {
  description = "Token del cliente para autenticación"
  value       = data.google_client_config.default.access_token
  sensitive   = true
}

output "node_pool_id" {
  description = "ID del node pool"
  value       = google_container_node_pool.primary.id
}
