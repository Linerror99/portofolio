# ============================================================================
# Variables pour l'environnement GCP Complete
# ============================================================================

variable "project_name" {
  description = "Nom du projet"
  type        = string
  default     = "portfolio"
}

variable "environment" {
  description = "Environnement (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "gcp_project_id" {
  description = "ID du projet GCP"
  type        = string
  # Sera défini dans terraform.tfvars
}

variable "gcp_region" {
  description = "Région GCP"
  type        = string
  default     = "us-west1"
}

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default = {
    Owner      = "LDjossou"
    Project    = "Portfolio"
    ManagedBy  = "Terraform"
    CostCenter = "Portfolio"
  }
}