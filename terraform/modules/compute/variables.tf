# ============================================================================
# MODULE: Compute - Variables
# ============================================================================
# Ce module déploie l'application containerisée en production
# - AWS : ECS Fargate + ALB + Route53 + Certificate Manager
# - GCP : Cloud Run + Load Balancer + Cloud DNS + SSL Certificate

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
  description = "Nom du projet (utilisé pour nommer les ressources)"
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
# VARIABLE: app_name
# ----------------------------------------------------------------------------
variable "app_name" {
  description = "Nom de l'application (pour le service)"
  type        = string
  default     = "app"
}

# ----------------------------------------------------------------------------
# VARIABLE: container_image
# ----------------------------------------------------------------------------
variable "container_image" {
  description = "URL complète de l'image Docker (registry_url:tag)"
  type        = string
  # Exemple AWS : 123456789012.dkr.ecr.us-west-1.amazonaws.com/portfolio-prod-app:latest
  # Exemple GCP : us-west1-docker.pkg.dev/portfolio-test-476200/portfolio-prod-app:latest
}

# ----------------------------------------------------------------------------
# VARIABLE: container_port
# ----------------------------------------------------------------------------
variable "container_port" {
  description = "Port exposé par le conteneur"
  type        = number
  default     = 80
  
  validation {
    condition     = var.container_port > 0 && var.container_port < 65536
    error_message = "container_port doit être entre 1 et 65535"
  }
}

# ----------------------------------------------------------------------------
# VARIABLE: cpu
# ----------------------------------------------------------------------------
variable "cpu" {
  description = "CPU alloué au conteneur (en millicores pour AWS, cores pour GCP)"
  type        = number
  default     = 256  # 0.25 vCPU pour AWS, 1 vCPU pour GCP
  
  validation {
    condition = contains([
      256, 512, 1024, 2048, 4096  # AWS Fargate CPU values
    ], var.cpu)
    error_message = "cpu doit être 256, 512, 1024, 2048 ou 4096 (AWS Fargate)"
  }
}

# ----------------------------------------------------------------------------
# VARIABLE: memory
# ----------------------------------------------------------------------------
variable "memory" {
  description = "Mémoire allouée au conteneur (en MB)"
  type        = number
  default     = 512  # 512 MB
  
  validation {
    condition     = var.memory >= 128 && var.memory <= 8192
    error_message = "memory doit être entre 128 MB et 8 GB"
  }
}

# ----------------------------------------------------------------------------
# VARIABLE: desired_count
# ----------------------------------------------------------------------------
variable "desired_count" {
  description = "Nombre d'instances du service à maintenir"
  type        = number
  default     = 1  # 1 instance par défaut (suffisant pour un portfolio)
  
  validation {
    condition     = var.desired_count >= 1 && var.desired_count <= 10
    error_message = "desired_count doit être entre 1 et 10"
  }
}

# ----------------------------------------------------------------------------
# VARIABLE: enable_autoscaling
# ----------------------------------------------------------------------------
variable "enable_autoscaling" {
  description = "Activer l'auto-scaling basé sur CPU/mémoire"
  type        = bool
  default     = false  # Pas besoin d'auto-scaling pour un portfolio
}

# ----------------------------------------------------------------------------
# VARIABLE: min_capacity
# ----------------------------------------------------------------------------
variable "min_capacity" {
  description = "Nombre minimum d'instances (si autoscaling activé)"
  type        = number
  default     = 1
}

# ----------------------------------------------------------------------------
# VARIABLE: max_capacity
# ----------------------------------------------------------------------------
variable "max_capacity" {
  description = "Nombre maximum d'instances (si autoscaling activé)"
  type        = number
  default     = 3
}

# ----------------------------------------------------------------------------
# VARIABLE: domain_name (optionnel)
# ----------------------------------------------------------------------------
variable "domain_name" {
  description = "Nom de domaine custom (ex: portfolio.ldjossou.dev). Optionnel."
  type        = string
  default     = ""
  # Si vide, on utilisera l'URL du load balancer
}

# ----------------------------------------------------------------------------
# VARIABLE: create_certificate
# ----------------------------------------------------------------------------
variable "create_certificate" {
  description = "Créer un certificat SSL/TLS pour HTTPS"
  type        = bool
  default     = false  # Pas de SSL par défaut, on configurera avec un vrai domaine
}

# ----------------------------------------------------------------------------
# VARIABLE: health_check_path
# ----------------------------------------------------------------------------
variable "health_check_path" {
  description = "Chemin pour le health check"
  type        = string
  default     = "/health"  # Notre app expose /health
}

# ----------------------------------------------------------------------------
# VARIABLES AWS SPÉCIFIQUES
# ----------------------------------------------------------------------------

variable "region" {
  description = "Région AWS (requis si cloud_provider = aws)"
  type        = string
  default     = "us-west-1"
}

variable "availability_zones" {
  description = "Zones de disponibilité AWS (au moins 2 pour ALB)"
  type        = list(string)
  default     = ["us-west-1a", "us-west-1c"]  # 2 AZ minimum
}

# ----------------------------------------------------------------------------
# VARIABLES GCP SPÉCIFIQUES
# ----------------------------------------------------------------------------

variable "gcp_project_id" {
  description = "ID du projet GCP (requis si cloud_provider = gcp)"
  type        = string
  default     = ""
}

variable "gcp_region" {
  description = "Région GCP (requis si cloud_provider = gcp)"
  type        = string
  default     = "us-west1"
}

variable "allow_unauthenticated" {
  description = "Autoriser l'accès public sans authentification (GCP)"
  type        = bool
  default     = true  # Portfolio public
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

# ----------------------------------------------------------------------------
# VARIABLE: enable_https
# ----------------------------------------------------------------------------
variable "enable_https" {
  description = "Activer HTTPS avec certificat SSL/TLS (nécessite un domaine valide)"
  type        = bool
  default     = false  # HTTP seulement par défaut
}