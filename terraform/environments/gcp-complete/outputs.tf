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