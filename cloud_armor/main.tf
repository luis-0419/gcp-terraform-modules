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
  dynamic "rule" {
    for_each = var.security_rules
    content {
      action      = rule.value.action
      priority    = rule.value.priority
      description = rule.value.description

      match {
        versioned_expr = rule.value.match.versioned_expr
        expr {
          expression = rule.value.match.expr.expression
        }
      }

      dynamic "rate_limit_options" {
        for_each = rule.value.rate_limit != null ? [rule.value.rate_limit] : []
        content {
          conform_action   = rate_limit_options.value.conform_action
          exceed_action    = rate_limit_options.value.exceed_action
          enforce_on_key   = rate_limit_options.value.enforce_on_key
          ban_duration_sec = rate_limit_options.value.ban_duration_sec

          rate_limit_threshold {
            count        = rate_limit_options.value.rate_limit_threshold.count
            interval_sec = rate_limit_options.value.rate_limit_threshold.interval_sec
          }
        }
      }
    }
  }

  # Nota: adaptive_protection_config se gestiona mediante google_compute_security_policy_rule
}
