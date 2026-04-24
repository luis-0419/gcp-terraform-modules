resource "google_compute_router" "router" {
  project = var.project_id
  name    = var.router_name
  region  = var.region
  network = var.network_name

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  project                    = var.project_id
  name                       = var.nat_name
  router                     = google_compute_router.router.name
  region                     = google_compute_router.router.region
  nat_ip_allocate_option     = var.nat_ip_allocate_option
  nat_ips                    = var.nat_ip_allocate_option == "MANUAL_ONLY" ? var.nat_ips : null
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat

  dynamic "subnetwork" {
    for_each = var.source_subnetwork_ip_ranges_to_nat == "LIST_OF_SUBNETWORKS" ? var.subnetworks : []
    content {
      name                    = subnetwork.value
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }

#   enable_logging = var.enable_logging
  log_config {
    enable = var.enable_logging
    filter = var.log_filter
  }

  tcp_established_idle_timeout_sec = var.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec  = var.tcp_transitory_idle_timeout_sec
  udp_idle_timeout_sec             = var.udp_idle_timeout_sec

  depends_on = [google_compute_router.router]
}
