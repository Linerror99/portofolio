# ============================================================================
# Variables pour l'environnement AWS
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

variable "region" {
  description = "Région AWS"
  type        = string
  default     = "us-west-1"
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
  description = "Tags supplémentaires"
  type        = map(string)
  default     = {}
}
