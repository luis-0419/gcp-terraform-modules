output "router_id" {
  description = "ID del router"
  value       = google_compute_router.router.id
}

output "router_name" {
  description = "Nombre del router"
  value       = google_compute_router.router.name
}

output "nat_id" {
  description = "ID del NAT"
  value       = google_compute_router_nat.nat.id
}

output "nat_name" {
  description = "Nombre del NAT"
  value       = google_compute_router_nat.nat.name
}
