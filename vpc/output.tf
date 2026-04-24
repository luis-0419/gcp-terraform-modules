output "network_name" {
  description = "Nombre de la VPC"
  value       = google_compute_network.vpc.name
}

output "network_id" {
  description = "ID de la VPC"
  value       = google_compute_network.vpc.id
}

output "network_self_link" {
  description = "URI de referencia propia de la VPC"
  value       = google_compute_network.vpc.self_link
}

output "subnets" {
  description = "Detalles de todas las subnets creadas"
  value = {
    for subnet_name, subnet in google_compute_subnetwork.subnets : subnet_name => {
      name              = subnet.name
      id                = subnet.id
      self_link         = subnet.self_link
      ip_cidr_range     = subnet.ip_cidr_range
      region            = subnet.region
      gateway_address   = subnet.gateway_address
      secondary_ranges  = [for range in subnet.secondary_ip_range : { range_name = range.range_name, ip_cidr_range = range.ip_cidr_range }]
    }
  }
}

output "subnet_names" {
  description = "Lista de nombres de las subnets"
  value       = [for subnet in google_compute_subnetwork.subnets : subnet.name]
}

output "subnet_ids" {
  description = "Lista de IDs de las subnets"
  value       = [for subnet in google_compute_subnetwork.subnets : subnet.id]
}

output "subnets_by_region" {
  description = "Subnets agrupadas por región"
  value = {
    for region in distinct([for subnet in var.subnets : subnet.region]) :
    region => [
      for subnet in google_compute_subnetwork.subnets :
      subnet.name if substr(subnet.self_link, -length(region), -1) == region
    ]
  }
}
