# Crear la instancia de máquina virtual
resource "google_compute_instance" "vm" {
  project      = var.project_id
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size  = var.boot_disk_size_gb
      type  = var.boot_disk_type
    }
  }

  network_interface {
    network    = var.network_interface.network
    subnetwork = var.network_interface.subnetwork

    # Asignar IP pública si se especifica
    dynamic "access_config" {
      for_each = var.network_interface.assign_public_ip ? [1] : []
      content {
        nat_ip = null
      }
    }
  }

  # Configuración de la cuenta de servicio
  service_account {
    email  = var.service_account_email
    scopes = var.scopes
  }

  # Metadata personalizada
  metadata = merge(
    var.metadata,
    var.startup_script != "" ? {
      startup-script = var.startup_script
    } : {},
    var.shutdown_script != "" ? {
      shutdown-script = var.shutdown_script
    } : {}
  )

  # Etiquetas
  labels = var.labels

  # Tags de red
  tags = var.tags

  # Política de reinicio
  scheduling {
    preemptible       = var.preemptible
    automatic_restart = var.auto_restart
  }

  # Discos adicionales
  dynamic "attached_disk" {
    for_each = var.additional_disks
    content {
      source      = google_compute_disk.additional_disks[attached_disk.key].id
      device_name = attached_disk.value.name
    }
  }

  depends_on = [
    google_compute_disk.additional_disks
  ]
}

# Crear discos adicionales si se especifican
resource "google_compute_disk" "additional_disks" {
  for_each = { for disk in var.additional_disks : disk.name => disk }

  project = var.project_id
  name    = each.value.name
  type    = each.value.type
  zone    = var.zone
  size    = each.value.size_gb

  labels = var.labels
}
