# =============================================================================
# MONITORING MODULE - Main Configuration
# =============================================================================
# Ce module configure le monitoring complet pour les services Cloud Run :
# - Notification channels (email)
# - Uptime checks (disponibilité des URLs)
# - Alerting policies (latence, erreurs, CPU, mémoire, attaques)
# - Log-based metrics (erreurs 4xx/5xx, requêtes suspectes)
# - Dashboard de monitoring
# =============================================================================

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# =============================================================================
# NOTIFICATION CHANNEL - Email
# =============================================================================

resource "google_monitoring_notification_channel" "email" {
  project      = var.gcp_project_id
  display_name = "${var.project_name}-${var.environment}-email-alerts"
  type         = "email"

  labels = {
    email_address = var.notification_email
  }

  user_labels = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

# =============================================================================
# LOG-BASED METRICS
# =============================================================================

# Metric: Count of 4xx client errors
resource "google_logging_metric" "client_errors_4xx" {
  project     = var.gcp_project_id
  name        = "${var.project_name}-${var.environment}-4xx-errors"
  description = "Count of 4xx client errors on Cloud Run"

  filter = <<-EOT
    resource.type="cloud_run_revision"
    ${var.cloud_run_service_name != "" ? "resource.labels.service_name=\"${var.cloud_run_service_name}\"" : ""}
    httpRequest.status>=400
    httpRequest.status<500
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "status_code"
      value_type  = "INT64"
      description = "HTTP status code"
    }
  }

  label_extractors = {
    "status_code" = "EXTRACT(httpRequest.status)"
  }
}

# Metric: Count of 5xx server errors
resource "google_logging_metric" "server_errors_5xx" {
  project     = var.gcp_project_id
  name        = "${var.project_name}-${var.environment}-5xx-errors"
  description = "Count of 5xx server errors on Cloud Run"

  filter = <<-EOT
    resource.type="cloud_run_revision"
    ${var.cloud_run_service_name != "" ? "resource.labels.service_name=\"${var.cloud_run_service_name}\"" : ""}
    httpRequest.status>=500
    httpRequest.status<600
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

# Metric: Count of suspicious/attack requests
resource "google_logging_metric" "suspicious_requests" {
  count       = var.enable_log_alerts ? 1 : 0
  project     = var.gcp_project_id
  name        = "${var.project_name}-${var.environment}-suspicious-requests"
  description = "Count of requests to suspicious paths (potential attacks)"

  filter = <<-EOT
    resource.type="cloud_run_revision"
    ${var.cloud_run_service_name != "" ? "resource.labels.service_name=\"${var.cloud_run_service_name}\"" : ""}
    (${join(" OR ", [for path in var.suspicious_paths : "httpRequest.requestUrl=~\"${path}\""])})
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "request_url"
      value_type  = "STRING"
      description = "Requested URL path"
    }

    labels {
      key         = "remote_ip"
      value_type  = "STRING"
      description = "Source IP address"
    }
  }

  label_extractors = {
    "request_url" = "EXTRACT(httpRequest.requestUrl)"
    "remote_ip"   = "EXTRACT(httpRequest.remoteIp)"
  }
}
