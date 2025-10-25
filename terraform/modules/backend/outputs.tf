# ============================================================================
# MODULE: Backend State Management - Outputs
# ============================================================================
# Ces outputs permettent à d'autres modules de récupérer les infos du backend
# Exemple : Le module "compute" peut lire "bucket_name" pour configurer son backend

# ----------------------------------------------------------------------------
# OUTPUT: Nom du bucket (AWS S3 ou GCP GCS)
# ----------------------------------------------------------------------------
output "bucket_name" {
  description = "Name of the backend state bucket (S3 for AWS, GCS for GCP)"
  value       = local.bucket_name
  # Exemple AWS : "portfolio-prod-tfstate"
  # Exemple GCP : "portfolio-prod-tfstate"
}

# ----------------------------------------------------------------------------
# OUTPUT: URL complète du bucket
# ----------------------------------------------------------------------------
output "bucket_url" {
  description = "Full URL of the backend state bucket"
  value       = local.bucket_url
  # Exemple AWS : "s3://portfolio-prod-tfstate"
  # Exemple GCP : "gs://portfolio-prod-tfstate"
}

# ----------------------------------------------------------------------------
# OUTPUT: ARN du bucket S3 (AWS seulement)
# ----------------------------------------------------------------------------
output "bucket_arn" {
  description = "ARN of the S3 bucket (AWS only, null for GCP)"
  value       = var.cloud_provider == "aws" && length(aws_s3_bucket.tfstate) > 0 ? aws_s3_bucket.tfstate[0].arn : null
  # Exemple : "arn:aws:s3:::portfolio-prod-tfstate"
  # GCP : null
}

# ----------------------------------------------------------------------------
# OUTPUT: Nom de la table DynamoDB (AWS seulement)
# ----------------------------------------------------------------------------
output "dynamodb_table" {
  description = "Name of the DynamoDB table for state locking (AWS only, null for GCP)"
  value       = local.dynamodb_table
  # Exemple AWS : "portfolio-prod-tfstate-lock"
  # GCP : null (GCP utilise le locking natif de GCS)
}

# ----------------------------------------------------------------------------
# OUTPUT: ARN de la table DynamoDB (AWS seulement)
# ----------------------------------------------------------------------------
output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table (AWS only, null for GCP)"
  value       = var.cloud_provider == "aws" && length(aws_dynamodb_table.tfstate_lock) > 0 ? aws_dynamodb_table.tfstate_lock[0].arn : null
  # Exemple : "arn:aws:dynamodb:us-east-1:123456789012:table/portfolio-prod-tfstate-lock"
  # GCP : null
}

# ----------------------------------------------------------------------------
# OUTPUT: Région du bucket
# ----------------------------------------------------------------------------
output "region" {
  description = "Region where the backend resources are created"
  value       = var.cloud_provider == "aws" ? var.region : var.gcp_region
  # Exemple AWS : "us-east-1"
  # Exemple GCP : "us-central1"
}

# ----------------------------------------------------------------------------
# OUTPUT: Configuration du backend (pour copier-coller dans d'autres modules)
# ----------------------------------------------------------------------------
output "backend_config" {
  description = "Backend configuration block ready to use in other Terraform projects"
  value = var.cloud_provider == "aws" ? {
    backend = "s3"
    config = {
      bucket         = local.bucket_name
      key            = "terraform.tfstate"  # À personnaliser par projet
      region         = var.region
      dynamodb_table = local.dynamodb_table
      encrypt        = true
    }
  } : {
    backend = "gcs"
    config = {
      bucket = local.bucket_name
      prefix = "terraform/state"  # À personnaliser par projet
    }
  }
  # AWS output :
  # {
  #   backend = "s3"
  #   config = {
  #     bucket = "portfolio-prod-tfstate"
  #     key = "terraform.tfstate"
  #     region = "us-east-1"
  #     dynamodb_table = "portfolio-prod-tfstate-lock"
  #     encrypt = true
  #   }
  # }
  
  # GCP output :
  # {
  #   backend = "gcs"
  #   config = {
  #     bucket = "portfolio-prod-tfstate"
  #     prefix = "terraform/state"
  #   }
  # }
}

# ----------------------------------------------------------------------------
# OUTPUT: Statut du versioning
# ----------------------------------------------------------------------------
output "versioning_enabled" {
  description = "Whether versioning is enabled on the state bucket"
  value       = var.enable_versioning
  # true ou false
}

# ----------------------------------------------------------------------------
# OUTPUT: Statut du chiffrement
# ----------------------------------------------------------------------------
output "encryption_enabled" {
  description = "Whether encryption is enabled on the state bucket"
  value       = var.enable_encryption
  # true ou false
}
