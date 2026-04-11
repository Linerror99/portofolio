# =============================================================================
# MONITORING MODULE - Outputs
# =============================================================================

output "notification_channel_id" {
  description = "ID du canal de notification email"
  value       = google_monitoring_notification_channel.email.name
}

output "uptime_check_ids" {
  description = "Map des IDs des uptime checks"
  value = {
    for name, check in google_monitoring_uptime_check_config.https :
    name => check.uptime_check_id
  }
}

output "dashboard_id" {
  description = "ID du dashboard de monitoring"
  value       = google_monitoring_dashboard.cloud_run.id
}

output "dashboard_url" {
  description = "URL directe du dashboard dans la console GCP"
  value       = "https://console.cloud.google.com/monitoring/dashboards/builder/${split("/", google_monitoring_dashboard.cloud_run.id)[length(split("/", google_monitoring_dashboard.cloud_run.id)) - 1]}?project=${var.gcp_project_id}"
}

output "alert_policy_ids" {
  description = "Map des IDs des alerting policies"
  value = merge(
    { for name, policy in google_monitoring_alert_policy.uptime_failure : "uptime-${name}" => policy.name },
    { for name, policy in google_monitoring_alert_policy.ssl_expiry : "ssl-${name}" => policy.name },
    var.cloud_run_service_name != "" ? {
      "high-latency"     = google_monitoring_alert_policy.high_latency[0].name
      "high-error-rate"  = google_monitoring_alert_policy.high_error_rate[0].name
      "high-cpu"         = google_monitoring_alert_policy.high_cpu[0].name
      "high-memory"      = google_monitoring_alert_policy.high_memory[0].name
      "request-spike"    = google_monitoring_alert_policy.request_spike[0].name
      "instance-count"   = google_monitoring_alert_policy.instance_count[0].name
    } : {},
    var.enable_log_alerts ? {
      "suspicious-requests" = google_monitoring_alert_policy.suspicious_requests[0].name
    } : {}
  )
}

output "log_metric_names" {
  description = "Noms des log-based metrics créées"
  value = {
    client_errors_4xx   = google_logging_metric.client_errors_4xx.name
    server_errors_5xx   = google_logging_metric.server_errors_5xx.name
    suspicious_requests = var.enable_log_alerts ? google_logging_metric.suspicious_requests[0].name : null
  }
}

output "monitoring_urls" {
  description = "URLs utiles pour le monitoring dans la console GCP"
  value = {
    dashboard         = "https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
    uptime_checks     = "https://console.cloud.google.com/monitoring/uptime?project=${var.gcp_project_id}"
    alerting_policies = "https://console.cloud.google.com/monitoring/alerting?project=${var.gcp_project_id}"
    incidents         = "https://console.cloud.google.com/monitoring/alerting/incidents?project=${var.gcp_project_id}"
    logs              = "https://console.cloud.google.com/logs?project=${var.gcp_project_id}"
    log_metrics       = "https://console.cloud.google.com/logs/metrics?project=${var.gcp_project_id}"
  }
}
