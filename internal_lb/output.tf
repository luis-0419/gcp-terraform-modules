output "forwarding_rule_id" {
  description = "ID de la regla de reenvío"
  value       = google_compute_forwarding_rule.default.id
}

output "forwarding_rule_ip_address" {
  description = "Dirección IP de la regla de reenvío"
  value       = google_compute_forwarding_rule.default.ip_address
}

output "backend_service_id" {
  description = "ID del servicio backend"
  value       = google_compute_region_backend_service.backend.id
}

output "health_check_id" {
  description = "ID del health check"
  value       = google_compute_region_health_check.tcp.id
}
