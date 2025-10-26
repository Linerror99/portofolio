# ============================================================================
# AWS COMPLETE - Déploiement Portfolio Complet
# ============================================================================
# Ce fichier déploie l'infrastructure complète sur AWS :
# - Backend State (S3 + DynamoDB)
# - Container Registry (ECR)
# - Compute (ECS Fargate + ALB)

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

# ============================================================================
# MODULE 1: BACKEND STATE
# ============================================================================
module "backend" {
  source = "../../modules/backend"
  
  cloud_provider    = "aws"
  project_name      = var.project_name
  environment       = var.environment
  region            = var.region
  enable_versioning = true
  enable_encryption = true
  
  tags = var.tags
}

# ============================================================================
# MODULE 2: CONTAINER REGISTRY
# ============================================================================
module "container_registry" {
  source = "../../modules/container-registry"
  
  cloud_provider          = "aws"
  project_name            = var.project_name
  environment             = var.environment
  repository_name         = "app"
  region                  = var.region
  scan_on_push            = true
  image_tag_mutability    = "MUTABLE"
  enable_lifecycle_policy = true
  image_retention_count   = 10
  
  tags = var.tags
}

# ============================================================================
# MODULE 3: COMPUTE
# ============================================================================
module "compute" {
  source = "../../modules/compute"
  
  # Dépend des autres modules
  depends_on = [module.backend, module.container_registry]
  
  cloud_provider = "aws"
  project_name   = var.project_name
  environment    = var.environment
  region         = var.region
  
  # Configuration de l'app
  app_name       = "portfolio-app"
  container_image = "${module.container_registry.registry_url}:latest"
  container_port = 8080
  cpu            = 512    # 0.5 vCPU
  memory         = 1024   # 1 GB RAM
  desired_count  = 1
  
  # Scaling (optionnel)
  enable_autoscaling = false  # Pas besoin pour un portfolio
  min_capacity      = 1
  max_capacity      = 3
  
  # Domaine (optionnel - on configurera plus tard)
  # custom_domain = "portfolio.ldjossou.dev"
  # enable_https = false  # Pas de SSL pour l'instant
  
  tags = var.tags
}

# ============================================================================
# OUTPUTS
# ============================================================================

# Backend
output "backend_bucket_name" {
  description = "Nom du bucket S3 pour le state"
  value       = module.backend.bucket_name
}

output "backend_dynamodb_table" {
  description = "Table DynamoDB pour le state locking"
  value       = module.backend.dynamodb_table
}

# Registry
output "registry_url" {
  description = "URL du registry ECR"
  value       = module.container_registry.registry_url
}

output "docker_commands" {
  description = "Commandes Docker pour pousser l'image"
  value       = module.container_registry.docker_commands
}

# Compute
output "app_url" {
  description = "🎯 URL PUBLIC de ton portfolio"
  value       = module.compute.app_url
}

output "load_balancer_dns" {
  description = "DNS du load balancer AWS"
  value       = module.compute.load_balancer_dns
}

output "service_name" {
  description = "Nom du service déployé"
  value       = module.compute.service_name
}

output "container_image" {
  description = "Image Docker utilisée"
  value       = module.compute.container_image
}

# 🚀 Instructions de déploiement
output "deployment_instructions" {
  description = "Instructions pour déployer ton app"
  value = <<-EOF
    
    🎉 INFRASTRUCTURE AWS CRÉÉE !
    
    📋 PROCHAINES ÉTAPES :
    
    1️⃣  BUILDER ET POUSSER L'IMAGE DOCKER :
       ${module.container_registry.docker_commands.login}
       cd ../../../app
       ${module.container_registry.docker_commands.build}
       ${module.container_registry.docker_commands.push}
    
    2️⃣  TON PORTFOLIO SERA ACCESSIBLE À :
       ${module.compute.app_url}
    
    3️⃣  POUR UN DOMAINE CUSTOM :
       - Achète un domaine (ex: ldjossou.dev)
       - Configure Route 53 
       - Ajoute custom_domain dans les variables
    
    📊 MONITORING :
       - ECS Console : https://console.aws.amazon.com/ecs/
       - CloudWatch Logs : Service ${module.compute.service_name}
    
  EOF
}