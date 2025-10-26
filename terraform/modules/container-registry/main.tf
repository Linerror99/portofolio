# ============================================================================
# MODULE: Container Registry - Main Configuration
# ============================================================================

# ============================================================================
# PARTIE 1 : CONTAINER REGISTRY AWS (ECR)
# ============================================================================

# ----------------------------------------------------------------------------
# RESOURCE: ECR Repository
# ----------------------------------------------------------------------------
# Créé SEULEMENT si cloud_provider = "aws"
resource "aws_ecr_repository" "main" {
  count = var.cloud_provider == "aws" ? 1 : 0

  # Nom du repository : portfolio-prod-app
  name = "${var.project_name}-${var.environment}-${var.repository_name}"

  # Mutabilité des tags (MUTABLE = on peut écraser un tag, IMMUTABLE = non)
  image_tag_mutability = var.image_tag_mutability

  # Scan automatique des vulnérabilités lors du push
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  # Chiffrement des images au repos (AES-256 par défaut)
  encryption_configuration {
    encryption_type = "AES256"
    # Pour utiliser KMS custom: encryption_type = "KMS", kms_key = "arn:aws:kms:..."
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-${var.environment}-${var.repository_name}"
      Environment = var.environment
      Type        = "ContainerRegistry"
    }
  )
}

# ----------------------------------------------------------------------------
# RESOURCE: ECR Lifecycle Policy
# ----------------------------------------------------------------------------
# Politique de rétention : garde seulement les N images les plus récentes
resource "aws_ecr_lifecycle_policy" "main" {
  count = var.cloud_provider == "aws" && var.enable_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.main[0].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.image_retention_count} images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = var.image_retention_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# ----------------------------------------------------------------------------
# RESOURCE: ECR Repository Policy (optionnel)
# ----------------------------------------------------------------------------
# Permet d'autoriser d'autres comptes AWS à pull les images
# Pour l'instant, on laisse privé (pas de policy)

# ============================================================================
# PARTIE 2 : CONTAINER REGISTRY GCP (Artifact Registry)
# ============================================================================

# ----------------------------------------------------------------------------
# RESOURCE: Artifact Registry Repository
# ----------------------------------------------------------------------------
# Créé SEULEMENT si cloud_provider = "gcp"
resource "google_artifact_registry_repository" "main" {
  count = var.cloud_provider == "gcp" ? 1 : 0

  location      = var.gcp_region
  project       = var.gcp_project_id
  repository_id = "${var.project_name}-${var.environment}-${var.repository_name}"
  description   = "Container registry for ${var.project_name} ${var.environment} environment"
  format        = "DOCKER"

  # Nettoyage automatique des images non taguées (optionnel)
  cleanup_policies {
    id     = "delete-untagged"
    action = "DELETE"
    condition {
      tag_state = "UNTAGGED"
      # Supprime les images non taguées après 7 jours
      older_than = "604800s" # 7 jours en secondes
    }
  }

  # Politique de rétention : garde les N images les plus récentes
  cleanup_policies {
    id     = "keep-recent-versions"
    action = "KEEP"
    most_recent_versions {
      keep_count = var.image_retention_count
    }
  }

  labels = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
    type        = "container-registry"
  }
}

# ----------------------------------------------------------------------------
# RESOURCE: Artifact Registry IAM (optionnel)
# ----------------------------------------------------------------------------
# Pour l'instant, on laisse les permissions par défaut du projet
# Si besoin, on peut ajouter des IAM bindings pour autoriser d'autres services

# ============================================================================
# PARTIE 3 : LOCALS (Variables calculées)
# ============================================================================

locals {
  # URL du registry (AWS ou GCP selon le provider)
  registry_url = var.cloud_provider == "aws" ? (
    length(aws_ecr_repository.main) > 0 ? aws_ecr_repository.main[0].repository_url : ""
  ) : (
    length(google_artifact_registry_repository.main) > 0 ? 
    "${var.gcp_region}-docker.pkg.dev/${var.gcp_project_id}/${google_artifact_registry_repository.main[0].repository_id}" : ""
  )

  # Nom du repository
  repository_name = var.cloud_provider == "aws" ? (
    length(aws_ecr_repository.main) > 0 ? aws_ecr_repository.main[0].name : ""
  ) : (
    length(google_artifact_registry_repository.main) > 0 ? google_artifact_registry_repository.main[0].repository_id : ""
  )

  # ARN du repository (AWS uniquement)
  repository_arn = var.cloud_provider == "aws" && length(aws_ecr_repository.main) > 0 ? (
    aws_ecr_repository.main[0].arn
  ) : null
}
