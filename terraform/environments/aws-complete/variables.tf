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

variable "domain_name" {
  description = "Nom de domaine personnalisé (ex: ldjossou.dev)"
  type        = string
  default     = ""
}

variable "create_route53_zone" {
  description = "Créer une zone Route 53 pour le domaine"
  type        = bool
  default     = false
}

# ----------------------------------------------------------------------------
# GCP CREDENTIALS (pour provider compatibility)
# ----------------------------------------------------------------------------
variable "gcp_credentials" {
  type        = string
  description = "GCP service account credentials JSON (for provider initialization only)"
  default     = ""
  sensitive   = true
}

# ----------------------------------------------------------------------------
# ECS CONFIGURATION (pour scaling dynamique)
# ----------------------------------------------------------------------------
variable "desired_count" {
  type        = number
  description = "Nombre d'instances ECS désirées (0 pour arrêter, 1+ pour activer)"
  default     = 1
  
  validation {
    condition     = var.desired_count >= 0 && var.desired_count <= 10
    error_message = "desired_count doit être entre 0 et 10"
  }
}
