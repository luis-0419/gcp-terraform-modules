output "policy_id" {
  description = "ID de la política de Cloud Armor"
  value       = google_compute_security_policy.policy.id
}

output "policy_name" {
  description = "Nombre de la política"
  value       = google_compute_security_policy.policy.name
}

output "policy_self_link" {
  description = "Self-link de la política"
  value       = google_compute_security_policy.policy.self_link
}
