resource "google_compute_global_address" "private_service_connection" {
  project       = var.project_id
  name          = "${var.service_connection_name}-psc-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network_id
}

resource "google_service_networking_connection" "private_service_connection" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_connection.name]
  depends_on              = [google_compute_global_address.private_service_connection]
}

resource "google_compute_private_service_connection_endpoint" "psc_endpoint" {
  project = var.project_id
  name    = var.service_connection_name
  region  = "us-central1"

  network                 = var.network_id
  service_attachment     = "projects/${var.project_id}/regions/us-central1/serviceAttachments/${var.service_name}"

  depends_on = [
    google_service_networking_connection.private_service_connection
  ]
}
