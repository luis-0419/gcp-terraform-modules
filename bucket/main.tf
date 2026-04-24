resource "google_storage_bucket" "bucket" {
  project           = var.project_id
  name              = var.bucket_name
  location          = var.location
  storage_class     = var.storage_class
  force_destroy     = false
  uniform_bucket_level_access = var.uniform_bucket_level_access

  dynamic "encryption" {
    for_each = var.enable_encryption ? [1] : []
    content {
      default_kms_key_name = var.kms_key_name
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action
        storage_class = lifecycle_rule.value.storage_class
      }
      condition {
        age                     = lifecycle_rule.value.age_days
        num_newer_versions      = lifecycle_rule.value.num_newer_versions
        matches_storage_class   = ["STANDARD"]
      }
    }
  }

  dynamic "cors" {
    for_each = var.cors_enabled ? [1] : []
    content {
      origin          = var.cors_origins
      method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
      response_header = ["Content-Type", "Authorization"]
      max_age_seconds = 3600
    }
  }

  labels = var.labels
}

# Bloquear acceso público por défault
resource "google_storage_bucket_iam_binding" "prevent_public_access" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  members = []
}
