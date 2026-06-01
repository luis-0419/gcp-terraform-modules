output "psc_endpoint_id" {
  description = "ID del endpoint PSC"
  value       = google_compute_forwarding_rule.psc_endpoint.id
}

output "psc_endpoint_name" {
  description = "Nombre del endpoint PSC"
  value       = google_compute_forwarding_rule.psc_endpoint.name
}

output "psc_endpoint_ip_address" {
  description = "Dirección IP del endpoint PSC"
  value       = google_compute_forwarding_rule.psc_endpoint.ip_address
}

output "reserved_ip_range_name" {
  description = "Nombre del rango de IP reservado"
  value       = google_compute_global_address.private_service_connection.name
}
