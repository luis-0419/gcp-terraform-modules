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

# Políticas de limpieza automática (se crean como recursos separados)
resource "google_artifact_registry_repository_cleanup_policy_attachment" "cleanup" {
  count = length(var.cleanup_policies) > 0 ? 1 : 0

  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.registry.repository_id

  dynamic "cleanup_policies" {
    for_each = var.cleanup_policies
    content {
      id     = cleanup_policies.value.id
      action = cleanup_policies.value.action

      condition {
        tag_state       = try(cleanup_policies.value.condition.tag_state, null)
        tag_prefixes    = try(cleanup_policies.value.condition.tag_prefixes, null)
        older_than_days = try(cleanup_policies.value.condition.older_than_days, null)
      }
    }
  }
}

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
