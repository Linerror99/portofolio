# ============================================================================
# OUTPUTS - GCP COMPLETE ENVIRONMENT
# ============================================================================

# Backend State
output "gcs_bucket_name" {
  description = "Nom du bucket GCS pour le state Terraform"
  value       = module.backend.bucket_name
}

# Container Registry
output "artifact_registry_url" {
  description = "URL du repository Artifact Registry"
  value       = module.container_registry.registry_url
}

# Compute
output "cloud_run_url" {
  description = "URL du service Cloud Run"
  value       = module.compute.cloud_run_url
}

output "cloud_run_service_name" {
  description = "Nom du service Cloud Run"
  value       = module.compute.cloud_run_service_name
}

output "app_url" {
  description = "URL complète pour accéder à l'application"
  value       = module.compute.app_url
}

# Docker commands
output "docker_commands" {
  description = "Commandes Docker pour pousser vers Artifact Registry"
  value       = module.container_registry.docker_commands
  sensitive   = true
}

# Health check
output "health_check_url" {
  description = "URL du health check"
  value       = "${module.compute.app_url}/health"
}

# ============================================================================
# Monitoring
# ============================================================================

output "monitoring_dashboard_url" {
  description = "URL du dashboard de monitoring GCP"
  value       = module.monitoring.dashboard_url
}

output "monitoring_urls" {
  description = "URLs utiles de la console de monitoring"
  value       = module.monitoring.monitoring_urls
}

output "uptime_check_ids" {
  description = "IDs des uptime checks"
  value       = module.monitoring.uptime_check_ids
}

output "alert_policy_ids" {
  description = "IDs des politiques d'alerte"
  value       = module.monitoring.alert_policy_ids
}