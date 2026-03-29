# =============================================================================
# MONITORING MODULE - Uptime Checks
# =============================================================================
# Vérifie la disponibilité de chaque URL toutes les X minutes
# Alerte par email si un site est down pendant > 5 minutes
# =============================================================================

# --- Uptime Checks pour chaque URL monitorée ---

resource "google_monitoring_uptime_check_config" "https" {
  for_each = { for idx, url in var.monitored_urls : url.display_name => url }

  project      = var.gcp_project_id
  display_name = "${var.project_name}-${var.environment}-uptime-${each.key}"
  timeout      = var.uptime_check_timeout
  period       = var.uptime_check_period

  http_check {
    path           = each.value.path
    port           = 443
    use_ssl        = true
    validate_ssl   = true
    request_method = "GET"

    accepted_response_status_codes {
      status_class = "STATUS_CLASS_2XX"
    }
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.gcp_project_id
      host       = each.value.host
    }
  }

  user_labels = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
    service     = lower(each.key)
  }
}

# --- Alerting Policy: Site Down ---
# Alerte si un uptime check échoue depuis TOUTES les régions

resource "google_monitoring_alert_policy" "uptime_failure" {
  for_each = { for idx, url in var.monitored_urls : url.display_name => url }

  project      = var.gcp_project_id
  display_name = "[${upper(var.environment)}] ${each.key} - Site Down"
  combiner     = "OR"

  conditions {
    display_name = "Uptime check failure for ${each.key}"

    condition_threshold {
      filter = <<-EOT
        resource.type = "uptime_url"
        AND metric.type = "monitoring.googleapis.com/uptime_check/check_passed"
        AND metric.labels.check_id = "${google_monitoring_uptime_check_config.https[each.key].uptime_check_id}"
      EOT

      comparison      = "COMPARISON_GT"
      threshold_value = 1
      duration        = "300s"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.label.project_id"]
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "Le site **${each.key}** (https://${each.value.host}${each.value.path}) est **DOWN**.\n\n**Actions recommandées:**\n1. Vérifier le statut du service Cloud Run dans la console GCP\n2. Vérifier les logs: `gcloud logging read 'resource.type=cloud_run_revision' --limit=50`\n3. Vérifier que le DNS pointe bien vers Cloud Run\n4. Vérifier le certificat SSL"
    mime_type = "text/markdown"
  }

  user_labels = {
    project     = var.project_name
    environment = var.environment
    severity    = "critical"
    type        = "uptime"
  }
}

# --- Alerting Policy: SSL Certificate Expiring ---

resource "google_monitoring_alert_policy" "ssl_expiry" {
  for_each = { for idx, url in var.monitored_urls : url.display_name => url }

  project      = var.gcp_project_id
  display_name = "[${upper(var.environment)}] ${each.key} - SSL Expiring Soon"
  combiner     = "OR"

  conditions {
    display_name = "SSL certificate expiring for ${each.key}"

    condition_threshold {
      filter = <<-EOT
        resource.type = "uptime_url"
        AND metric.type = "monitoring.googleapis.com/uptime_check/time_until_ssl_cert_expires"
        AND metric.labels.check_id = "${google_monitoring_uptime_check_config.https[each.key].uptime_check_id}"
      EOT

      comparison      = "COMPARISON_LT"
      threshold_value = 15
      duration        = "600s"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "1200s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["resource.label.host"]
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  alert_strategy {
    auto_close = "86400s"
  }

  documentation {
    content   = "Le certificat SSL pour **${each.key}** (https://${each.value.host}) expire dans moins de **15 jours**.\n\n**Actions:**\n1. Si Cloudflare gère le SSL: vérifier le renouvellement automatique\n2. Si Cloud Run managed: il se renouvelle automatiquement\n3. Vérifier: `echo | openssl s_client -connect ${each.value.host}:443 2>/dev/null | openssl x509 -noout -dates`"
    mime_type = "text/markdown"
  }

  user_labels = {
    project     = var.project_name
    environment = var.environment
    severity    = "warning"
    type        = "ssl"
  }
}
