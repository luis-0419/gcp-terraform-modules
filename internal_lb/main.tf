# 1. Cambiado a google_compute_region_health_check (Debe ser regional)
resource "google_compute_region_health_check" "tcp" {
  project = var.project_id
  name    = "${var.load_balancer_name}-health-check"
  region  = var.region # REQUERIDO: Debes definir la región

  tcp_health_check {
    port         = var.health_check_port
    # request y response no son obligatorios si están vacíos, los puedes omitir
  }

  check_interval_sec  = var.health_check_interval
  timeout_sec         = var.health_check_timeout
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold
}

# 2. Cambiado a google_compute_region_backend_service
resource "google_compute_region_backend_service" "backend" {
  project               = var.project_id
  name                  = "${var.load_balancer_name}-backend"
  region                = var.region # REQUERIDO
  protocol              = var.protocol # Asegúrate de que var.protocol sea "TCP"
  timeout_sec           = var.timeout_sec
  load_balancing_scheme = "INTERNAL"
  
  # Se eliminó 'port_name = "http"' (esto es solo para capa 7)
  # Se eliminó 'enable_cdn = false' (CDN no es compatible con L4)
  
  # Apunta al ID del health check regional
  health_checks         = [google_compute_region_health_check.tcp.id]
  session_affinity      = var.session_affinity
}

# 3. La regla de reenvío también debe ser regional y requiere la red/subred
resource "google_compute_forwarding_rule" "default" {
  project               = var.project_id
  name                  = var.load_balancer_name
  region                = var.region # REQUERIDO
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  ports                 = [var.port] 
  
  # Se eliminó 'port_range' porque para INTERNAL L4 se usa 'ports' o 'all_ports'
  
  backend_service       = google_compute_region_backend_service.backend.id
  
  # REQUERIDO: Un Load Balancer interno necesita vivir en una subred específica
  network               = var.network_id     # El nombre o self_link de tu VPC
  subnetwork            = var.subnetwork_id  # El nombre o self_link de tu subred
  
  labels                = var.labels
}
