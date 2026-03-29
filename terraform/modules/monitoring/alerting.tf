# =============================================================================
# MONITORING MODULE - Alerting Policies
# =============================================================================
# Policies pour Cloud Run : latence, erreurs, CPU, mémoire, attaques
# =============================================================================

# --- Alert: High Request Latency (p99 > threshold) ---

resource "google_monitoring_alert_policy" "high_latency" {
  count = var.cloud_run_service_name != "" ? 1 : 0

  project      = var.gcp_project_id
  display_name = "[${upper(var.environment)}] Cloud Run - High Latency (>${var.latency_threshold_ms}ms)"
  combiner     = "OR"

  conditions {
    display_name = "Request latency p99 > ${var.latency_threshold_ms}ms"

    condition_threshold {
      filter = <<-EOT
        resource.type = "cloud_run_revision"
        AND resource.labels.service_name = "${var.cloud_run_service_name}"
        AND metric.type = "run.googleapis.com/request_latencies"
      EOT

      comparison      = "COMPARISON_GT"
      threshold_value = var.latency_threshold_ms
      duration        = "300s"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_PERCENTILE_99"
        cross_series_reducer = "REDUCE_MAX"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "La latence p99 du service **${var.cloud_run_service_name}** dépasse **${var.latency_threshold_ms}ms**.\n\n**Causes possibles:**\n- Cold start (scale from zero)\n- Charge élevée\n- Problème réseau\n\n**Actions:**\n1. Vérifier les logs: `gcloud logging read 'resource.type=cloud_run_revision AND resource.labels.service_name=${var.cloud_run_service_name}' --limit=50`\n2. Vérifier le nombre d'instances\n3. Augmenter min_instances si cold starts fréquents"
    mime_type = "text/markdown"
  }

  user_labels = {
    project     = var.project_name
    environment = var.environment
    severity    = "warning"
    type        = "latency"
  }
}

# --- Alert: High Error Rate (5xx) ---

resource "google_monitoring_alert_policy" "high_error_rate" {
  count = var.cloud_run_service_name != "" ? 1 : 0

  project      = var.gcp_project_id
  display_name = "[${upper(var.environment)}] Cloud Run - High Error Rate (5xx)"
  combiner     = "OR"

  conditions {
    display_name = "5xx error rate > ${var.error_rate_threshold * 100}%"

    condition_threshold {
      filter = <<-EOT
        resource.type = "cloud_run_revision"
        AND resource.labels.service_name = "${var.cloud_run_service_name}"
        AND metric.type = "run.googleapis.com/request_count"
        AND metric.labels.response_code_class = "5xx"
      EOT

      comparison      = "COMPARISON_GT"
      threshold_value = 5
      duration        = "300s"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "Le taux d'erreurs 5xx sur **${var.cloud_run_service_name}** est élevé.\n\n**Actions:**\n1. Vérifier les logs d'erreur: `gcloud logging read 'resource.type=cloud_run_revision AND resource.labels.service_name=${var.cloud_run_service_name} AND httpRequest.status>=500' --limit=50`\n2. Vérifier la santé du container\n3. Vérifier les limites de ressources (CPU/mémoire)"
    mime_type = "text/markdown"
  }

  user_labels = {
    project     = var.project_name
    environment = var.environment
    severity    = "critical"
    type        = "errors"
  }
}

# --- Alert: High CPU Utilization ---

resource "google_monitoring_alert_policy" "high_cpu" {
  count = var.cloud_run_service_name != "" ? 1 : 0

  project      = var.gcp_project_id
  display_name = "[${upper(var.environment)}] Cloud Run - High CPU (>${var.cpu_threshold * 100}%)"
  combiner     = "OR"

  conditions {
    display_name = "CPU utilization > ${var.cpu_threshold * 100}%"

    condition_threshold {
      filter = <<-EOT
        resource.type = "cloud_run_revision"
        AND resource.labels.service_name = "${var.cloud_run_service_name}"
        AND metric.type = "run.googleapis.com/container/cpu/utilizations"
      EOT

      comparison      = "COMPARISON_GT"
      threshold_value = var.cpu_threshold
      duration        = "300s"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_PERCENTILE_99"
        cross_series_reducer = "REDUCE_MAX"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "L'utilisation CPU du service **${var.cloud_run_service_name}** dépasse **${var.cpu_threshold * 100}%**.\n\n**Causes possibles:**\n- Attaque DDoS\n- Charge légitime élevée\n- Boucle infinie dans le code\n\n**Actions:**\n1. Vérifier le nombre de requêtes (spike = possible attaque)\n2. Vérifier l'autoscaling\n3. Augmenter les limites CPU si nécessaire"
    mime_type = "text/markdown"
  }

  user_labels = {
    project     = var.project_name
    environment = var.environment
    severity    = "warning"
    type        = "resources"
  }
}

# --- Alert: High Memory Utilization ---

resource "google_monitoring_alert_policy" "high_memory" {
  count = var.cloud_run_service_name != "" ? 1 : 0

  project      = var.gcp_project_id
  display_name = "[${upper(var.environment)}] Cloud Run - High Memory (>${var.memory_threshold * 100}%)"
  combiner     = "OR"

  conditions {
    display_name = "Memory utilization > ${var.memory_threshold * 100}%"

    condition_threshold {
      filter = <<-EOT
        resource.type = "cloud_run_revision"
        AND resource.labels.service_name = "${var.cloud_run_service_name}"
        AND metric.type = "run.googleapis.com/container/memory/utilizations"
      EOT

      comparison      = "COMPARISON_GT"
      threshold_value = var.memory_threshold
      duration        = "300s"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_PERCENTILE_99"
        cross_series_reducer = "REDUCE_MAX"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "L'utilisation mémoire du service **${var.cloud_run_service_name}** dépasse **${var.memory_threshold * 100}%**.\n\n**Actions:**\n1. Vérifier les fuites mémoire dans les logs\n2. Augmenter la limite mémoire si nécessaire\n3. Identifier les requêtes gourmandes"
    mime_type = "text/markdown"
  }

  user_labels = {
    project     = var.project_name
    environment = var.environment
    severity    = "warning"
    type        = "resources"
  }
}

# --- Alert: Request Spike (Potential Attack) ---

resource "google_monitoring_alert_policy" "request_spike" {
  count = var.cloud_run_service_name != "" ? 1 : 0

  project      = var.gcp_project_id
  display_name = "[${upper(var.environment)}] Cloud Run - Request Spike (Potential Attack)"
  combiner     = "OR"

  conditions {
    display_name = "Request count > ${var.request_count_spike_threshold}/min"

    condition_threshold {
      filter = <<-EOT
        resource.type = "cloud_run_revision"
        AND resource.labels.service_name = "${var.cloud_run_service_name}"
        AND metric.type = "run.googleapis.com/request_count"
      EOT

      comparison      = "COMPARISON_GT"
      threshold_value = var.request_count_spike_threshold
      duration        = "60s"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "Le service **${var.cloud_run_service_name}** reçoit un nombre anormalement élevé de requêtes (>${var.request_count_spike_threshold}/min).\n\n**Cela peut indiquer une attaque DDoS ou un bot.**\n\n**Actions immédiates:**\n1. Vérifier les IPs sources dans les logs:\n   `gcloud logging read 'resource.type=cloud_run_revision AND resource.labels.service_name=${var.cloud_run_service_name}' --format='table(httpRequest.remoteIp, httpRequest.requestUrl)' --limit=100`\n2. Si attaque confirmée: activer Cloud Armor ou bloquer via Cloudflare\n3. Vérifier le coût actuel dans Billing\n4. Réduire max_instances temporairement pour limiter les coûts"
    mime_type = "text/markdown"
  }

  user_labels = {
    project     = var.project_name
    environment = var.environment
    severity    = "critical"
    type        = "security"
  }
}

# --- Alert: Instance Count Anomaly ---

resource "google_monitoring_alert_policy" "instance_count" {
  count = var.cloud_run_service_name != "" ? 1 : 0

  project      = var.gcp_project_id
  display_name = "[${upper(var.environment)}] Cloud Run - High Instance Count (>${var.instance_count_threshold})"
  combiner     = "OR"

  conditions {
    display_name = "Instance count > ${var.instance_count_threshold}"

    condition_threshold {
      filter = <<-EOT
        resource.type = "cloud_run_revision"
        AND resource.labels.service_name = "${var.cloud_run_service_name}"
        AND metric.type = "run.googleapis.com/container/instance_count"
      EOT

      comparison      = "COMPARISON_GT"
      threshold_value = var.instance_count_threshold
      duration        = "120s"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MAX"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "Le nombre d'instances du service **${var.cloud_run_service_name}** dépasse **${var.instance_count_threshold}**.\n\nCela peut indiquer un traffic anormal ou une attaque en cours.\n\n**Actions:**\n1. Vérifier les requêtes entrantes\n2. Vérifier le coût dans Billing\n3. Réduire max_instances si nécessaire: `gcloud run services update ${var.cloud_run_service_name} --max-instances=3`"
    mime_type = "text/markdown"
  }

  user_labels = {
    project     = var.project_name
    environment = var.environment
    severity    = "warning"
    type        = "scaling"
  }
}

# --- Alert: Suspicious Requests (Attack Detection) ---

resource "google_monitoring_alert_policy" "suspicious_requests" {
  count = var.enable_log_alerts ? 1 : 0

  project      = var.gcp_project_id
  display_name = "[${upper(var.environment)}] Security - Suspicious Requests Detected"
  combiner     = "OR"

  conditions {
    display_name = "Suspicious requests > 10/5min"

    condition_threshold {
      filter = <<-EOT
        resource.type = "cloud_run_revision"
        AND metric.type = "logging.googleapis.com/user/${google_logging_metric.suspicious_requests[0].name}"
      EOT

      comparison      = "COMPARISON_GT"
      threshold_value = 10
      duration        = "0s"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  alert_strategy {
    auto_close = "3600s"
  }

  documentation {
    content   = "Des requêtes suspectes ont été détectées sur le portfolio.\n\nPaths surveillés: ${join(", ", var.suspicious_paths)}\n\n**Actions:**\n1. Identifier les IPs sources dans Cloud Logging\n2. Bloquer les IPs via Cloudflare (Security > WAF > Tools > IP Access Rules)\n3. Vérifier qu'aucun fichier sensible n'est exposé"
    mime_type = "text/markdown"
  }

  user_labels = {
    project     = var.project_name
    environment = var.environment
    severity    = "high"
    type        = "security"
  }
}
