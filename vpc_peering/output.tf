output "peering_name" {
  description = "Nombre del peering local a peer"
  value       = google_compute_network_peering.local_to_peer.name
}

output "peering_id" {
  description = "ID del peering local a peer"
  value       = google_compute_network_peering.local_to_peer.id
}

output "peering_state" {
  description = "Estado del peering local a peer"
  value       = google_compute_network_peering.local_to_peer.state
}

output "local_network_name" {
  description = "Nombre de la red local"
  value       = data.google_compute_network.local_network.name
}

output "peer_network_name" {
  description = "Nombre de la red peer"
  value       = data.google_compute_network.peer_network.name
}

output "reverse_peering_name" {
  description = "Nombre del peering inverso (si está habilitado)"
  value       = var.create_reverse_peering ? google_compute_network_peering.peer_to_local[0].name : null
}

output "reverse_peering_id" {
  description = "ID del peering inverso (si está habilitado)"
  value       = var.create_reverse_peering ? google_compute_network_peering.peer_to_local[0].id : null
}

output "reverse_peering_state" {
  description = "Estado del peering inverso (si está habilitado)"
  value       = var.create_reverse_peering ? google_compute_network_peering.peer_to_local[0].state : null
}

output "local_network_id" {
  description = "ID de la red local"
  value       = data.google_compute_network.local_network.id
}

output "peer_network_id" {
  description = "ID de la red peer"
  value       = data.google_compute_network.peer_network.id
}

output "peering_details" {
  description = "Detalles completos del peering"
  value = {
    local_to_peer = {
      name                                  = google_compute_network_peering.local_to_peer.name
      id                                    = google_compute_network_peering.local_to_peer.id
      state                                 = google_compute_network_peering.local_to_peer.state
      export_custom_routes                  = google_compute_network_peering.local_to_peer.export_custom_routes
      import_custom_routes                  = google_compute_network_peering.local_to_peer.import_custom_routes
    }
    peer_to_local = var.create_reverse_peering ? {
      name                                  = google_compute_network_peering.peer_to_local[0].name
      id                                    = google_compute_network_peering.peer_to_local[0].id
      state                                 = google_compute_network_peering.peer_to_local[0].state
      export_custom_routes                  = google_compute_network_peering.peer_to_local[0].export_custom_routes
      import_custom_routes                  = google_compute_network_peering.peer_to_local[0].import_custom_routes
    } : null
  }
}
