# ============================================================================
# TEST AWS - Backend State Module
# ============================================================================

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configuration du provider AWS
provider "aws" {
  region = var.region
  
  # Tags par défaut appliqués à toutes les ressources
  default_tags {
    tags = {
      Project     = "Portfolio"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}

# Appel du module backend
module "backend" {
  source = "../../modules/backend"
  
  # Variables requises
  cloud_provider = "aws"
  project_name   = var.project_name
  
  # Variables optionnelles (avec override)
  environment       = var.environment
  region            = var.region
  enable_versioning = var.enable_versioning
  enable_encryption = var.enable_encryption
  
  tags = var.tags
}

# Afficher les outputs du module
output "bucket_name" {
  description = "Nom du bucket S3 créé"
  value       = module.backend.bucket_name
}

output "bucket_url" {
  description = "URL du bucket S3"
  value       = module.backend.bucket_url
}

output "bucket_arn" {
  description = "ARN du bucket S3"
  value       = module.backend.bucket_arn
}

output "dynamodb_table" {
  description = "Nom de la table DynamoDB"
  value       = module.backend.dynamodb_table
}

output "dynamodb_table_arn" {
  description = "ARN de la table DynamoDB"
  value       = module.backend.dynamodb_table_arn
}

output "backend_config" {
  description = "Configuration du backend à copier-coller"
  value       = module.backend.backend_config
}
