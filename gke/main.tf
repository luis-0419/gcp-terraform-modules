resource "google_container_cluster" "primary" {
  provider   = google
  project    = var.project_id
  name       = var.cluster_name
  location   = var.location
  network    = var.network_name
  subnetwork = var.subnetwork_name

  # Configuración de nodos predeterminada
  remove_default_node_pool = true
  initial_node_count       = 1

  # Rangos secundarios de IP para Kubernetes
  dynamic "ip_allocation_policy" {
    for_each = var.enable_ip_alias ? [1] : []
    content {
      cluster_secondary_range_name  = var.cluster_secondary_range_name != "" ? var.cluster_secondary_range_name : null
      services_secondary_range_name = var.services_secondary_range_name != "" ? var.services_secondary_range_name : null
      cluster_ipv4_cidr_block       = var.cluster_ipv4_cidr_block != "" ? var.cluster_ipv4_cidr_block : null
      services_ipv4_cidr_block      = var.services_ipv4_cidr_block != "" ? var.services_ipv4_cidr_block : null
    }
  }

  # Network Policy
  network_policy {
    enabled  = var.enable_network_policy
    provider = var.enable_network_policy ? "PROVIDER_UNSPECIFIED" : "PROVIDER_UNSPECIFIED"
  }

  # Release channel
  release_channel {
    channel = var.release_channel
  }

  # Seguridad
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    network_policy_config {
      disabled = !var.enable_network_policy
    }
  }

#   shielded_nodes {
#     enabled = var.enable_shielded_nodes
#   }

  # Logging
  logging_service = var.enable_log_sink ? "logging.googleapis.com/kubernetes" : "none"

#   labels = var.labels

  depends_on = [
    data.google_client_config.default,
  ]

  lifecycle {
    ignore_changes = [node_pool, initial_node_count]
  }
}

# Node pool
resource "google_container_node_pool" "primary" {
  provider   = google
  project    = var.project_id
  name       = "${var.cluster_name}-node-pool"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = var.enable_autoscaling ? null : var.initial_node_count

  autoscaling {
    min_node_count = var.enable_autoscaling ? var.min_node_count : null
    max_node_count = var.enable_autoscaling ? var.max_node_count : null
  }

  node_config {
    preemptible  = var.preemptible_nodes
    machine_type = var.machine_type
    
    disk_size_gb = 50
    disk_type    = "pd-standard"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = merge(
      var.labels,
      {
        "node_pool" = "primary"
      }
    )

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = false
  }
}

data "google_client_config" "default" {
  provider = google
}
