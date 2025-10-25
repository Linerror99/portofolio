# ============================================================================
# MODULE: Container Registry - Outputs
# ============================================================================

# ----------------------------------------------------------------------------
# OUTPUT: URL du registry
# ----------------------------------------------------------------------------
output "registry_url" {
  description = "URL du container registry"
  value       = local.registry_url
  # AWS : 123456789012.dkr.ecr.us-west-1.amazonaws.com/portfolio-prod-app
  # GCP : us-west1-docker.pkg.dev/portfolio-test-476200/portfolio-prod-app
}

# ----------------------------------------------------------------------------
# OUTPUT: Nom du repository
# ----------------------------------------------------------------------------
output "repository_name" {
  description = "Nom du repository"
  value       = local.repository_name
  # AWS : portfolio-prod-app
  # GCP : portfolio-prod-app
}

# ----------------------------------------------------------------------------
# OUTPUT: ARN du repository (AWS uniquement)
# ----------------------------------------------------------------------------
output "repository_arn" {
  description = "ARN du repository ECR (AWS uniquement, null pour GCP)"
  value       = local.repository_arn
  # AWS : arn:aws:ecr:us-west-1:123456789012:repository/portfolio-prod-app
  # GCP : null
}

# ----------------------------------------------------------------------------
# OUTPUT: ID du repository (GCP uniquement)
# ----------------------------------------------------------------------------
output "repository_id" {
  description = "ID du repository Artifact Registry (GCP uniquement, null pour AWS)"
  value = var.cloud_provider == "gcp" && length(google_artifact_registry_repository.main) > 0 ? (
    google_artifact_registry_repository.main[0].id
  ) : null
  # GCP : projects/portfolio-test-476200/locations/us-west1/repositories/portfolio-prod-app
  # AWS : null
}

# ----------------------------------------------------------------------------
# OUTPUT: Région
# ----------------------------------------------------------------------------
output "region" {
  description = "Région où le registry est créé"
  value       = var.cloud_provider == "aws" ? var.region : var.gcp_region
  # AWS : us-west-1
  # GCP : us-west1
}

# ----------------------------------------------------------------------------
# OUTPUT: Scan automatique activé
# ----------------------------------------------------------------------------
output "scan_on_push_enabled" {
  description = "Indique si le scan automatique est activé"
  value       = var.scan_on_push
}

# ----------------------------------------------------------------------------
# OUTPUT: Politique de rétention activée
# ----------------------------------------------------------------------------
output "lifecycle_policy_enabled" {
  description = "Indique si la politique de rétention est activée"
  value       = var.enable_lifecycle_policy
}

# ----------------------------------------------------------------------------
# OUTPUT: Nombre d'images conservées
# ----------------------------------------------------------------------------
output "image_retention_count" {
  description = "Nombre d'images conservées par la politique de rétention"
  value       = var.image_retention_count
}

# ----------------------------------------------------------------------------
# OUTPUT: Commandes Docker (helper)
# ----------------------------------------------------------------------------
output "docker_commands" {
  description = "Commandes Docker pour utiliser le registry"
  value = var.cloud_provider == "aws" ? {
    login = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${local.registry_url}"
    build = "docker build -t ${local.registry_url}:latest ."
    push  = "docker push ${local.registry_url}:latest"
    pull  = "docker pull ${local.registry_url}:latest"
  } : {
    login = "gcloud auth configure-docker ${var.gcp_region}-docker.pkg.dev"
    build = "docker build -t ${local.registry_url}:latest ."
    push  = "docker push ${local.registry_url}:latest"
    pull  = "docker pull ${local.registry_url}:latest"
  }
  # Retourne un objet avec les commandes Docker prêtes à l'emploi
}
