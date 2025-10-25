# ============================================================================
# TEST GCP - Backend State Module
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

# Configuration du provider GCP
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Appel du module backend
module "backend" {
  source = "../../modules/backend"
  
  # Variables requises
  cloud_provider = "gcp"
  project_name   = var.project_name
  
  # Variables optionnelles (avec override)
  environment       = var.environment
  gcp_project_id    = var.gcp_project_id
  gcp_region        = var.gcp_region
  enable_versioning = var.enable_versioning
  enable_encryption = var.enable_encryption
  
  tags = var.tags
}

# Afficher les outputs du module
output "bucket_name" {
  description = "Nom du bucket GCS créé"
  value       = module.backend.bucket_name
}

output "bucket_url" {
  description = "URL du bucket GCS"
  value       = module.backend.bucket_url
}

output "region" {
  description = "Région GCP"
  value       = module.backend.region
}

output "backend_config" {
  description = "Configuration du backend à copier-coller"
  value       = module.backend.backend_config
}

output "versioning_enabled" {
  description = "Statut du versioning"
  value       = module.backend.versioning_enabled
}

output "encryption_enabled" {
  description = "Statut du chiffrement"
  value       = module.backend.encryption_enabled
}
