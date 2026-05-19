output "instance_name" {
  description = "Nombre de la instancia de VM"
  value       = google_compute_instance.vm.name
}

output "instance_id" {
  description = "ID de la instancia de VM"
  value       = google_compute_instance.vm.id
}

output "instance_self_link" {
  description = "URI de referencia propia de la instancia"
  value       = google_compute_instance.vm.self_link
}

output "internal_ip" {
  description = "IP interna de la VM"
  value       = google_compute_instance.vm.network_interface[0].network_ip
}

output "external_ip" {
  description = "IP externa de la VM (si está asignada)"
  value       = try(google_compute_instance.vm.network_interface[0].access_config[0].nat_ip, null)
}

output "machine_type" {
  description = "Tipo de máquina"
  value       = google_compute_instance.vm.machine_type
}

output "zone" {
  description = "Zona de GCP donde está la VM"
  value       = google_compute_instance.vm.zone
}

output "status" {
  description = "Estado actual de la VM"
  value       = google_compute_instance.vm.current_status
}

output "service_account_email" {
  description = "Email de la cuenta de servicio"
  value       = google_compute_instance.vm.service_account[0].email
}

output "network_interface" {
  description = "Detalles de la interfaz de red"
  value = {
    network    = google_compute_instance.vm.network_interface[0].network
    subnetwork = google_compute_instance.vm.network_interface[0].subnetwork
    network_ip = google_compute_instance.vm.network_interface[0].network_ip
  }
}

output "labels" {
  description = "Etiquetas de la VM"
  value       = google_compute_instance.vm.labels
}

output "tags" {
  description = "Tags de red de la VM"
  value       = google_compute_instance.vm.tags
}

output "additional_disks_info" {
  description = "Información de los discos adicionales"
  value = {
    for disk_name, disk in google_compute_disk.additional_disks : disk_name => {
      id        = disk.id
      self_link = disk.self_link
      size_gb   = disk.size_gb
      type      = disk.type
    }
  }
}

output "vm_details" {
  description = "Detalles completos de la VM"
  value = {
    name             = google_compute_instance.vm.name
    id               = google_compute_instance.vm.id
    machine_type     = google_compute_instance.vm.machine_type
    zone             = google_compute_instance.vm.zone
    internal_ip      = google_compute_instance.vm.network_interface[0].network_ip
    external_ip      = try(google_compute_instance.vm.network_interface[0].access_config[0].nat_ip, null)
    status           = google_compute_instance.vm.current_status
    preemptible      = google_compute_instance.vm.scheduling[0].preemptible
    auto_restart     = google_compute_instance.vm.scheduling[0].automatic_restart
  }
}
