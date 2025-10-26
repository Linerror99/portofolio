# ============================================================================
# TEST AWS - Container Registry Module
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

provider "aws" {
  region = var.region
}

# Appel du module container-registry
module "container_registry" {
  source = "../../modules/container-registry"
  
  # Variables requises
  cloud_provider   = "aws"
  project_name     = var.project_name
  environment      = var.environment
  repository_name  = var.repository_name
  region           = var.region
  
  # Configuration
  scan_on_push            = var.scan_on_push
  image_tag_mutability    = var.image_tag_mutability
  enable_lifecycle_policy = var.enable_lifecycle_policy
  image_retention_count   = var.image_retention_count
  
  tags = var.tags
}

# Outputs
output "registry_url" {
  description = "URL du registry ECR"
  value       = module.container_registry.registry_url
}

output "repository_name" {
  description = "Nom du repository"
  value       = module.container_registry.repository_name
}

output "repository_arn" {
  description = "ARN du repository"
  value       = module.container_registry.repository_arn
}

output "docker_commands" {
  description = "Commandes Docker pour utiliser le registry"
  value       = module.container_registry.docker_commands
}
