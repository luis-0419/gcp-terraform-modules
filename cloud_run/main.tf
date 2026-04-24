resource "google_cloud_run_service" "service" {
  project  = var.project_id
  name     = var.service_name
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.cloud_run.email
      timeout_seconds      = var.timeout_seconds
      container_concurrency = 80

      containers {
        image = var.image

        resources {
          requests = {
            memory = var.memory
            cpu    = var.cpu
          }
        }

        # env = [for key, value in var.environment_variables : {
        #   name  = key
        #   value = value
        # }]

        dynamic "env" {
          for_each = var.secret_environment_variables
          content {
            name = env.key
            value_from {
              secret_key_ref {
                name = env.value.secret_name
                key  = env.value.version
              }
            }
          }
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/min-scale"        = var.min_instances
        "autoscaling.knative.dev/max-scale"        = var.max_instances
        "run.googleapis.com/cloudsql-instances"    = ""
        "run.googleapis.com/client-name"           = "terraform"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

#   labels = var.labels
}

# Service account para Cloud Run
resource "google_service_account" "cloud_run" {
  project     = var.project_id
  account_id  = "${var.service_name}-sa"
  display_name = "Service Account for ${var.service_name}"
}

# IAM Policy - Allow public access
resource "google_cloud_run_service_iam_member" "public" {
  count   = var.allow_public_access ? 1 : 0
  project = var.project_id
  service = google_cloud_run_service.service.name
  role    = "roles/run.invoker"
  member  = "allUsers"
  location = var.region
}
