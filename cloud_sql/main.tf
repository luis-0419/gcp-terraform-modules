resource "google_sql_database_instance" "instance" {
  project             = var.project_id
  name                = var.instance_name
  database_version    = var.database_version
  region              = var.region
  deletion_protection = false

  settings {
    tier              = var.tier
    availability_type = var.availability_type
    disk_size         = var.disk_size
    disk_type         = var.disk_type

    backup_configuration {
      enabled                        = var.backup_enabled
      start_time                     = var.backup_start_time
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
    }

    ip_configuration {
    #   require_ssl            = true
    #   enable_private_path    = var.private_network != null ? true : false
      private_network        = var.private_network
      ipv4_enabled           = var.enable_public_ip
    #   authorized_networks    = var.enable_public_ip ? [{ name = "allow-all", value = "0.0.0.0/0" }] : []
    #   enable_private_path    = false
    }

    user_labels = var.labels

    insights_config {
      query_insights_enabled  = true
      query_string_length    = 1024
      record_application_tags = true
    }

    maintenance_window {
    #   kind           = "MAINTENANCE_WINDOW_KIND_UNSPECIFIED"
      update_track   = "stable"
      day            = 7  # Domingo
      hour           = 3
    #   update_frequency = 5
    }
  }

  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]
}

resource "google_sql_database" "databases" {
  project = var.project_id
  name    = var.database_name
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "users" {
  project  = var.project_id
  name     = var.username
  instance = google_sql_database_instance.instance.name
  password = var.user_password
}

# Conexión VPC para Private IP
resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = var.private_network != null ? 1 : 0
  provider                = google-beta
  service                 = "servicenetworking.googleapis.com"
  network                 = var.private_network
  reserved_peering_ranges = [google_compute_global_address.private_ip_address[0].name]
}

resource "google_compute_global_address" "private_ip_address" {
  count         = var.private_network != null ? 1 : 0
  project       = var.project_id
  name          = "${var.instance_name}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.private_network
}
