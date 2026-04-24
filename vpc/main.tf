
# Crear la VPC
resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode            = var.routing_mode
  description             = var.description

  # labels = var.labels

  # Prevenir que Terraform elimine la VPC durante una operación de destrucción
  # Cambiar a false si deseas permitir la eliminación
  delete_default_routes_on_create = false
}

# Crear subnets
resource "google_compute_subnetwork" "subnets" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  project = var.project_id
  name    = each.value.name
  region  = each.value.region

  network       = google_compute_network.vpc.id
  ip_cidr_range = each.value.ip_cidr_range

  private_ip_google_access = each.value.private_ip_google_access

  # Habilitar flow logs si se especifica
  dynamic "log_config" {
    for_each = each.value.enable_flow_logs ? [1] : []
    content {
      aggregation_interval = "INTERVAL_5_SEC"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }

  # Crear rangos IP secundarios (para GKE, por ejemplo)
  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  # labels = var.labels

  depends_on = [google_compute_network.vpc]
}

# Rutas por defecto (solo crear si es necesario)
# Nota: Por defecto, GCP crea rutas default que se pueden referenciar con:
# google_compute_network.vpc.default_network
