# ============================================================================
# MODULE: Container Registry - Variables
# ============================================================================
# Ce module crée un registry pour stocker les images Docker
# - AWS : Elastic Container Registry (ECR)
# - GCP : Artifact Registry

# ----------------------------------------------------------------------------
# VARIABLE: cloud_provider
# ----------------------------------------------------------------------------
variable "cloud_provider" {
  description = "Cloud provider à utiliser (aws ou gcp)"
  type        = string
  
  validation {
    condition     = contains(["aws", "gcp"], var.cloud_provider)
    error_message = "cloud_provider doit être 'aws' ou 'gcp'"
  }
}

# ----------------------------------------------------------------------------
# VARIABLE: project_name
# ----------------------------------------------------------------------------
variable "project_name" {
  description = "Nom du projet (utilisé pour nommer le registry)"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9-]{3,30}$", var.project_name))
    error_message = "project_name doit contenir 3-30 caractères (minuscules, chiffres, tirets)"
  }
}

# ----------------------------------------------------------------------------
# VARIABLE: environment
# ----------------------------------------------------------------------------
variable "environment" {
  description = "Environnement (dev, staging, prod)"
  type        = string
  default     = "prod"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment doit être 'dev', 'staging' ou 'prod'"
  }
}

# ----------------------------------------------------------------------------
# VARIABLE: repository_name
# ----------------------------------------------------------------------------
variable "repository_name" {
  description = "Nom du repository (ex: portfolio-app)"
  type        = string
  default     = "app"
  
  validation {
    condition     = can(regex("^[a-z0-9-]{1,256}$", var.repository_name))
    error_message = "repository_name doit contenir 1-256 caractères (minuscules, chiffres, tirets)"
  }
}

# ----------------------------------------------------------------------------
# VARIABLE: region (AWS uniquement)
# ----------------------------------------------------------------------------
variable "region" {
  description = "Région AWS (requis si cloud_provider = aws)"
  type        = string
  default     = "us-west-1"
}

# ----------------------------------------------------------------------------
# VARIABLE: gcp_project_id (GCP uniquement)
# ----------------------------------------------------------------------------
variable "gcp_project_id" {
  description = "ID du projet GCP (requis si cloud_provider = gcp)"
  type        = string
  default     = ""
}

# ----------------------------------------------------------------------------
# VARIABLE: gcp_region (GCP uniquement)
# ----------------------------------------------------------------------------
variable "gcp_region" {
  description = "Région GCP (requis si cloud_provider = gcp)"
  type        = string
  default     = "us-west1"
}

# ----------------------------------------------------------------------------
# VARIABLE: image_tag_mutability (AWS uniquement)
# ----------------------------------------------------------------------------
variable "image_tag_mutability" {
  description = "Mutabilité des tags d'images (MUTABLE ou IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
  
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability doit être 'MUTABLE' ou 'IMMUTABLE'"
  }
}

# ----------------------------------------------------------------------------
# VARIABLE: scan_on_push
# ----------------------------------------------------------------------------
variable "scan_on_push" {
  description = "Activer le scan automatique des images lors du push"
  type        = bool
  default     = true
}

# ----------------------------------------------------------------------------
# VARIABLE: enable_lifecycle_policy
# ----------------------------------------------------------------------------
variable "enable_lifecycle_policy" {
  description = "Activer la politique de rétention des images"
  type        = bool
  default     = true
}

# ----------------------------------------------------------------------------
# VARIABLE: image_retention_count
# ----------------------------------------------------------------------------
variable "image_retention_count" {
  description = "Nombre d'images à conserver (les plus récentes)"
  type        = number
  default     = 10
  
  validation {
    condition     = var.image_retention_count > 0 && var.image_retention_count <= 1000
    error_message = "image_retention_count doit être entre 1 et 1000"
  }
}

# ----------------------------------------------------------------------------
# VARIABLE: tags
# ----------------------------------------------------------------------------
variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}
