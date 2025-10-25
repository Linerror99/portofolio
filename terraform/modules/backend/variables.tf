# ============================================================================
# MODULE: Backend State Management
# Description: Crée le backend pour stocker le state Terraform (S3 ou GCS)
# ============================================================================

# ----------------------------------------------------------------------------
# VARIABLE: cloud_provider
# ----------------------------------------------------------------------------
# Définit quel cloud utiliser : "aws" ou "gcp"
# Cette variable détermine quelles ressources seront créées
variable "cloud_provider" {
  description = "Cloud provider à utiliser (aws ou gcp)"
  type        = string
  
  # Validation : accepte seulement "aws" ou "gcp"
  validation {
    condition     = contains(["aws", "gcp"], var.cloud_provider)
    error_message = "cloud_provider doit être 'aws' ou 'gcp'"
  }
}

# ----------------------------------------------------------------------------
# VARIABLE: project_name
# ----------------------------------------------------------------------------
# Nom du projet, utilisé pour nommer les ressources
# Exemple : "portfolio" → "portfolio-tfstate-bucket"
variable "project_name" {
  description = "Nom du projet (utilisé pour nommer les ressources)"
  type        = string
  
  # Validation : doit être entre 3 et 30 caractères, alphanumériques et tirets
  validation {
    condition     = can(regex("^[a-z0-9-]{3,30}$", var.project_name))
    error_message = "project_name doit contenir 3-30 caractères (minuscules, chiffres, tirets)"
  }
}

# ----------------------------------------------------------------------------
# VARIABLE: environment
# ----------------------------------------------------------------------------
# Environnement du déploiement (dev, staging, prod)
# Permet d'avoir plusieurs states séparés
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
# VARIABLE: region (AWS uniquement)
# ----------------------------------------------------------------------------
# Région AWS où créer le bucket S3
# N'est utilisé que si cloud_provider = "aws"
variable "region" {
  description = "Région AWS (requis si cloud_provider = aws)"
  type        = string
  default     = "us-west-1"
}

# ----------------------------------------------------------------------------
# VARIABLE: gcp_project_id (GCP uniquement)
# ----------------------------------------------------------------------------
# ID du projet GCP où créer le bucket GCS
# N'est utilisé que si cloud_provider = "gcp"
variable "gcp_project_id" {
  description = "ID du projet GCP (requis si cloud_provider = gcp)"
  type        = string
  default     = ""
}

# ----------------------------------------------------------------------------
# VARIABLE: gcp_region (GCP uniquement)
# ----------------------------------------------------------------------------
# Région GCP où créer le bucket GCS
variable "gcp_region" {
  description = "Région GCP (requis si cloud_provider = gcp)"
  type        = string
  default     = "us-west1"
}

# ----------------------------------------------------------------------------
# VARIABLE: enable_versioning
# ----------------------------------------------------------------------------
# Active le versioning du state (garder l'historique des changements)
# Recommandé : true (permet de rollback en cas d'erreur)
variable "enable_versioning" {
  description = "Activer le versioning du bucket"
  type        = bool
  default     = true
}

# ----------------------------------------------------------------------------
# VARIABLE: enable_encryption
# ----------------------------------------------------------------------------
# Active le chiffrement du state
# Recommandé : true (sécurité)
variable "enable_encryption" {
  description = "Activer le chiffrement du bucket"
  type        = bool
  default     = true
}

# ----------------------------------------------------------------------------
# VARIABLE: tags
# ----------------------------------------------------------------------------
# Tags à appliquer aux ressources (pour organisation et facturation)
variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default = {
    Project     = "Portfolio"
    ManagedBy   = "Terraform"
    Environment = "Production"
  }
}
