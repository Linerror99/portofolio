# ============================================================================
# Variables pour l'environnement GCP
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
  description = "ID du projet GCP (requis pour GCP)"
  type        = string
  # Pas de défaut - doit être fourni dans terraform.tfvars
}

variable "gcp_region" {
  description = "Région GCP"
  type        = string
  default     = "us-west1"
}

variable "enable_versioning" {
  description = "Activer le versioning du bucket"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Activer le chiffrement du bucket"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Labels supplémentaires pour GCP"
  type        = map(string)
  default     = {}
}
