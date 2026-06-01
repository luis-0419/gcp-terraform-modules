# Crear el repositorio de Artifact Registry
resource "google_artifact_registry_repository" "registry" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_name
  description   = var.repository_description
  format        = var.repository_format

  # Escaneo de vulnerabilidades (solo para DOCKER)
  docker_config {
    immutable_tags = var.enable_immutable_tags
  }

  # Configuración de limpieza automática (se gestiona mediante google_artifact_registry_cleanup_policies)
  # Las cleanup_policies se crean como recursos separados

  labels = var.labels
}

# Nota: Las políticas de limpieza deben configurarse a través de gcloud CLI o la consola
# Terraform tiene soporte limitado para cleanup_policies en Artifact Registry

# Configuración del escaneo de vulnerabilidades (solo para DOCKER)
resource "google_artifact_registry_repository_iam_member" "docker_reader" {
  count = var.repository_format == "DOCKER" && var.enable_vulnerability_scanning ? 1 : 0

  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
}

# Obtener información del proyecto
data "google_project" "project" {
  project_id = var.project_id
}
