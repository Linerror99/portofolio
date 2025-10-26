# ============================================================================
# Variables pour l'environnement AWS Complete
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

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default = {
    Owner      = "LDjossou"
    Project    = "Portfolio"
    ManagedBy  = "Terraform"
  }
}

variable "enable_https" {
  description = "Activer HTTPS (nécessite un domaine valide)"
  type        = bool
  default     = false
}