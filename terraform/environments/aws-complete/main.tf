# ============================================================================
# AWS COMPLETE - Déploiement Portfolio Complet
# ============================================================================
# Ce fichier déploie l'infrastructure complète sur AWS :
# - Backend State (S3 + DynamoDB)
# - Container Registry (ECR)
# - Compute (ECS Fargate + ALB)

terraform {
  required_version = ">= 1.0"
  
  # Backend S3 pour stocker l'état Terraform de manière partagée
  backend "s3" {
    bucket         = "portfolio-prod-tfstate"
    key            = "aws-complete/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "portfolio-prod-tfstate-lock"
    encrypt        = true
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Provider Google vide pour satisfaire les modules multi-cloud
# Ce provider n'est pas utilisé dans l'environnement AWS mais requis par les modules
provider "google" {
  project = "portfolio-test-476200"
  region  = "us-west1"
  
  # Utiliser les credentials du service account si disponibles
  credentials = var.gcp_credentials != "" ? var.gcp_credentials : null
}

# ============================================================================
# MODULE 1: BACKEND STATE
# ============================================================================
# Le S3 bucket et la table DynamoDB seront gérés par Terraform
# Si ils existent déjà, Terraform les importera automatiquement

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
  
  # Configuration HTTPS et domaine personnalisé
  domain_name         = var.domain_name
  enable_https        = var.enable_https
  create_certificate  = var.enable_https
  route53_zone_id     = var.create_route53_zone && var.domain_name != "" ? aws_route53_zone.main[0].zone_id : ""
  
  tags = var.tags
}

# ============================================================================
# MODULE 4: DNS (ROUTE 53) - Optionnel
# ============================================================================
resource "aws_route53_zone" "main" {
  count = var.create_route53_zone && var.domain_name != "" ? 1 : 0

  name = var.domain_name

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-dns-zone"
      Type = "DNSZone"
    }
  )
}

# Enregistrement A pour le domaine principal
resource "aws_route53_record" "main" {
  count = var.create_route53_zone && var.domain_name != "" ? 1 : 0

  zone_id = aws_route53_zone.main[0].zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.compute.load_balancer_dns
    zone_id                = module.compute.load_balancer_zone_id
    evaluate_target_health = true
  }
}

# Enregistrement A pour le sous-domaine www
resource "aws_route53_record" "www" {
  count = var.create_route53_zone && var.domain_name != "" ? 1 : 0

  zone_id = aws_route53_zone.main[0].zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.compute.load_balancer_dns
    zone_id                = module.compute.load_balancer_zone_id
    evaluate_target_health = true
  }
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

# ============================================================================
# OUTPUTS - Voir outputs.tf pour les outputs détaillés
# ============================================================================