# ============================================================================
# ENVIRONNEMENT GCP COMPLETE - Configuration Terraform
# ============================================================================
# Ce fichier configure l'infrastructure complète sur Google Cloud Platform
# - Backend : GCS (Google Cloud Storage) pour le state Terraform
# - Registry : Artifact Registry pour les images Docker
# - Compute : Cloud Run pour l'application containerisée

terraform {
  required_version = ">= 1.6"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # Backend GCS configuration
  backend "gcs" {
    bucket = "portfolio-prod-tfstate"
    prefix = "gcp-complete/terraform.tfstate"
  }
}

# ============================================================================
# PROVIDER CONFIGURATION
# ============================================================================

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project_id
}

# Provider AWS (requis pour l'initialisation des modules, même si non utilisé ici)
provider "aws" {
  region = "us-west-1"
  # Les credentials AWS seront fournis par les variables d'environnement du workflow
}

# ============================================================================
# MODULE 1: BACKEND STATE (GCS)
# ============================================================================
module "backend" {
  source = "../../modules/backend"
  
  cloud_provider     = "gcp"
  project_name       = var.project_name
  environment        = var.environment
  gcp_project_id     = var.gcp_project_id
  gcp_region         = var.gcp_region
  enable_versioning  = true
  enable_encryption  = true
  
  tags = var.tags
}

# ============================================================================
# MODULE 2: CONTAINER REGISTRY (Artifact Registry)
# ============================================================================
module "container_registry" {
  source = "../../modules/container-registry"
  
  cloud_provider        = "gcp"
  project_name          = var.project_name
  environment           = var.environment
  gcp_project_id        = var.gcp_project_id
  gcp_region            = var.gcp_region
  scan_on_push          = true
  enable_lifecycle_policy = true
  image_retention_count = 10
  
  tags = var.tags
}

# ============================================================================
# MODULE 3: COMPUTE (Cloud Run)
# ============================================================================
module "compute" {
  source = "../../modules/compute"
  
  # Configuration cloud
  cloud_provider     = "gcp"
  project_name       = var.project_name
  environment        = var.environment
  gcp_project_id     = var.gcp_project_id
  gcp_region         = var.gcp_region
  
  # Configuration de l'app
  app_name              = "portfolio-app"
  container_image       = "${module.container_registry.registry_url}/portfolio-app:latest"
  container_port        = 8080
  cpu                   = 1024    # 1024 millicores pour Cloud Run (équivalent 1 vCPU)
  memory                = 1024    # 1 GB RAM
  desired_count         = 1
  
  # Scaling (optionnel)
  enable_autoscaling    = true    # Cloud Run scale automatiquement
  min_capacity          = 0       # Scale to zero sur Cloud Run
  max_capacity          = 10      # Max 10 instances
  
  # Configuration domaine (désactivé pour l'instant)
  domain_name           = ""      # Pas de domaine pour cette phase
  enable_https          = false   # HTTPS par défaut sur Cloud Run
  create_certificate    = false   # Pas de certificat custom
  
  # Sécurité
  allow_unauthenticated = true    # Portfolio public
  
  tags = var.tags
}