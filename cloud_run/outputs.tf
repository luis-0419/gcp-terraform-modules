output "service_name" {
  description = "Nombre del servicio Cloud Run"
  value       = google_cloud_run_service.service.name
}

output "service_url" {
  description = "URL del servicio Cloud Run"
  value       = google_cloud_run_service.service.status[0].url
}

output "service_account_email" {
  description = "Email de la cuenta de servicio"
  value       = google_service_account.cloud_run.email
}
