output "bucket_name" {
  description = "Nombre del bucket"
  value       = google_storage_bucket.bucket.name
}

output "bucket_id" {
  description = "ID del bucket"
  value       = google_storage_bucket.bucket.id
}

output "bucket_self_link" {
  description = "Self-link del bucket"
  value       = google_storage_bucket.bucket.self_link
}

output "bucket_url" {
  description = "URL del bucket"
  value       = "gs://${google_storage_bucket.bucket.name}"
}
