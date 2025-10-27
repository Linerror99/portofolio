# ============================================================================
# TEST GCP - Container Registry Module
# ============================================================================

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Appel du module container-registry
module "container_registry" {
  source = "../../modules/container-registry"
  
  # Variables requises
  cloud_provider   = "gcp"
  project_name     = var.project_name
  environment      = var.environment
  repository_name  = var.repository_name
  gcp_project_id   = var.gcp_project_id
  gcp_region       = var.gcp_region
  
  # Configuration
  scan_on_push            = var.scan_on_push
  enable_lifecycle_policy = var.enable_lifecycle_policy
  image_retention_count   = var.image_retention_count
  
  tags = var.tags
}

# Outputs
output "registry_url" {
  description = "URL du registry Artifact Registry"
  value       = module.container_registry.registry_url
}

output "repository_name" {
  description = "Nom du repository"
  value       = module.container_registry.repository_name
}

output "repository_id" {
  description = "ID du repository"
  value       = module.container_registry.repository_id
}

output "docker_commands" {
  description = "Commandes Docker pour utiliser le registry"
  value       = module.container_registry.docker_commands
}
