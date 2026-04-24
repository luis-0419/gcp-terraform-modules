resource "google_compute_security_policy" "policy" {
  project     = var.project_id
  name        = var.policy_name
  description = var.description

#   # Regla por defecto
#   rules {
#     action      = "allow"
#     priority    = 65534
#     description = "Regla por defecto"
#     match {
#       versioned_expr = "SOC_V2"
#       expr {
#         expression = "true"
#       }
#     }
#   }

  # Rules adicionales
  dynamic "rules" {
    for_each = var.security_rules
    content {
      action      = rules.value.action
      priority    = rules.value.priority
      description = rules.value.description

      match {
        versioned_expr = rules.value.match.versioned_expr
        expr {
          expression = rules.value.match.expr.expression
        }
      }

      dynamic "rate_limit_options" {
        for_each = rules.value.rate_limit != null ? [rules.value.rate_limit.rate_limit_options] : []
        content {
          conform_action             = rate_limit_options.value.conform_action
          exceed_action              = rate_limit_options.value.exceed_action
          enforce_on_key             = rate_limit_options.value.enforce_on_key
          requests_per_interval      = rate_limit_options.value.requests_per_interval
          interval_sec               = rate_limit_options.value.interval_sec
          ban_duration_sec           = 600
        }
      }
    }
  }

  # Defensive DDoS
  dynamic "adaptive_protection_config" {
    for_each = var.enable_layer7_ddos_defense ? [1] : []
    content {
      layer_7_ddos_defense_config {
        enable          = true
        rule_visibility = "STANDARD"
      }
    }
  }
}
