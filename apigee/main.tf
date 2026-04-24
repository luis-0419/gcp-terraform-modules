resource "google_apigee_organization" "organization" {
  analytics_region   = var.analytics_region
  project_id         = var.project_id
  display_name       = var.organization_name
  description        = var.description

#   properties = var.enable_mtls ? {
#     features = "mTLS,DebugMask,EnvConfig,SharedFlow,MessageFlow,MessageProcessor"
#   } : {}

  depends_on = []
}

resource "google_apigee_environment" "environment" {
#   project_id  = var.project_id
  org_id      = google_apigee_organization.organization.id
  name        = var.environment_name
  display_name = var.environment_name
  description = var.environment_description
  type        = var.environment_type

    # properties {
    #     property = concat(
    #     [for key, value in var.environment_properties : {
    #         name  = key
    #         value = value
    #     }],
    #     [{
    #         name  = "environment.type"
    #         value = var.environment_type
    #     }]
    #     )
    # }

  depends_on = [
    google_apigee_organization.organization
  ]
}

resource "google_apigee_envgroup" "envgroup" {
#   project_id  = var.project_id
  org_id      = google_apigee_organization.organization.id
  name        = "${var.environment_name}-group"
  hostnames   = ["${var.environment_name}-api.example.com"]

  depends_on = [
    google_apigee_environment.environment
  ]
}
