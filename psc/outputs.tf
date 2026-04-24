output "psc_endpoint_id" {
  description = "ID del endpoint PSC"
  value       = google_compute_private_service_connection_endpoint.psc_endpoint.id
}

output "psc_endpoint_name" {
  description = "Nombre del endpoint PSC"
  value       = google_compute_private_service_connection_endpoint.psc_endpoint.name
}

output "reserved_ip_range_name" {
  description = "Nombre del rango de IP reservado"
  value       = google_compute_global_address.private_service_connection.name
}
