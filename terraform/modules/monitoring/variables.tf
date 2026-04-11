# =============================================================================
# MONITORING MODULE - Variables
# =============================================================================

variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-west1"
}

variable "project_name" {
  description = "Project name for naming resources"
  type        = string
  default     = "portfolio"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "prod"
}

# --- Notification ---

variable "notification_email" {
  description = "Email address for alert notifications"
  type        = string
}

# --- Uptime Checks ---

variable "monitored_urls" {
  description = "List of URLs to monitor with uptime checks"
  type = list(object({
    display_name = string
    host         = string
    path         = string
  }))
  default = []
}

variable "uptime_check_period" {
  description = "How often to run uptime checks (in seconds). Minimum 60s."
  type        = string
  default     = "300s"
}

variable "uptime_check_timeout" {
  description = "Timeout for uptime checks (in seconds)"
  type        = string
  default     = "10s"
}

# --- Cloud Run Service ---

variable "cloud_run_service_name" {
  description = "Cloud Run service name (for metrics filtering)"
  type        = string
  default     = ""
}

# --- Alert Thresholds ---

variable "latency_threshold_ms" {
  description = "Request latency threshold in ms to trigger alert"
  type        = number
  default     = 5000
}

variable "error_rate_threshold" {
  description = "Error rate threshold (0-1) to trigger alert. 0.05 = 5%"
  type        = number
  default     = 0.05
}

variable "request_count_spike_threshold" {
  description = "Request count per minute above which to alert (potential attack)"
  type        = number
  default     = 500
}

variable "cpu_threshold" {
  description = "CPU utilization threshold (0-1) to trigger alert"
  type        = number
  default     = 0.8
}

variable "memory_threshold" {
  description = "Memory utilization threshold (0-1) to trigger alert"
  type        = number
  default     = 0.8
}

variable "instance_count_threshold" {
  description = "Instance count above which to alert (scaling anomaly)"
  type        = number
  default     = 5
}

# --- Log-based Alerts ---

variable "enable_log_alerts" {
  description = "Enable log-based alerting for suspicious patterns"
  type        = bool
  default     = true
}

variable "suspicious_paths" {
  description = "URL paths that indicate attack attempts (e.g., /wp-admin, /phpmyadmin)"
  type        = list(string)
  default = [
    "/wp-admin",
    "/wp-login",
    "/phpmyadmin",
    "/.env",
    "/xmlrpc.php",
    "/wp-content",
    "/admin",
    "/api/v1",
    "/.git",
    "/config",
    "/backup",
    "/shell",
    "/cmd",
    "/eval",
  ]
}

variable "tags" {
  description = "Labels for resources"
  type        = map(string)
  default     = {}
}
