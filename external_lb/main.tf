resource "google_compute_health_check" "tcp" {
  project = var.project_id
  name    = "${var.load_balancer_name}-health-check"

  tcp_health_check {
    port         = var.health_check_port
    request      = ""
    response     = ""
  }

  check_interval_sec  = var.health_check_interval
  timeout_sec         = var.health_check_timeout
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold
}

resource "google_compute_backend_service" "backend" {
  project             = var.project_id
  name                = "${var.load_balancer_name}-backend"
  protocol            = var.protocol
  port_name           = "http"
  timeout_sec         = var.timeout_sec
  load_balancing_scheme = "EXTERNAL"
  health_checks       = [google_compute_health_check.tcp.id]
  session_affinity    = var.session_affinity

  enable_cdn = false
}

resource "google_compute_forwarding_rule" "default" {
  project       = var.project_id
  name          = var.load_balancer_name
  ip_protocol   = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range    = var.port
  ports         = [var.port]
  backend_service = google_compute_backend_service.backend.id
  
  # Conectar a la VPC especificada
  network      = var.network_name != null ? var.network_name : null
  subnetwork   = var.subnetwork_name != null ? var.subnetwork_name : null
  
  labels = var.labels
}
