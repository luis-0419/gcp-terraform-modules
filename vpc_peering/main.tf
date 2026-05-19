# Obtener referencias a las redes locales y peers
data "google_compute_network" "local_network" {
  name    = var.local_network_name
  project = var.project_id
}

data "google_compute_network" "peer_network" {
  name    = var.peer_network_name
  project = var.peer_project_id
}

# Generar nombres de peering automáticamente si no se proporcionan
locals {
  peering_name = var.peering_name != null ? var.peering_name : "${var.local_network_name}-to-${var.peer_network_name}"
  reverse_peering_name = var.create_reverse_peering ? (
    var.reverse_peering_name != null ? var.reverse_peering_name : "${var.peer_network_name}-to-${var.local_network_name}"
  ) : null
}

# Crear peering de la red local a la red peer
resource "google_compute_network_peering" "local_to_peer" {
  name         = local.peering_name
  network      = data.google_compute_network.local_network.self_link
  peer_network = data.google_compute_network.peer_network.self_link

  export_custom_routes     = var.export_custom_routes
  import_custom_routes     = var.import_custom_routes
  export_subnet_routes_with_public_ip = var.export_subnet_routes_with_public_ip
  import_subnet_routes_with_public_ip = var.import_subnet_routes_with_public_ip

  depends_on = [
    data.google_compute_network.local_network,
    data.google_compute_network.peer_network
  ]
}

# Crear peering inverso (de la red peer a la red local) si se especifica
resource "google_compute_network_peering" "peer_to_local" {
  count = var.create_reverse_peering ? 1 : 0

  name         = local.reverse_peering_name
  network      = data.google_compute_network.peer_network.self_link
  peer_network = data.google_compute_network.local_network.self_link

  export_custom_routes     = var.export_custom_routes
  import_custom_routes     = var.import_custom_routes
  export_subnet_routes_with_public_ip = var.export_subnet_routes_with_public_ip
  import_subnet_routes_with_public_ip = var.import_subnet_routes_with_public_ip

  depends_on = [
    google_compute_network_peering.local_to_peer
  ]
}
