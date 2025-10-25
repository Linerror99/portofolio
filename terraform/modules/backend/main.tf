# ============================================================================
# MODULE: Backend State Management - Main Configuration
# ============================================================================

# ============================================================================
# PARTIE 1 : BACKEND AWS (S3 + DynamoDB)
# ============================================================================

# ----------------------------------------------------------------------------
# RESOURCE: S3 Bucket pour stocker le state
# ----------------------------------------------------------------------------
# Créé SEULEMENT si cloud_provider = "aws"
# count = 1 si AWS, sinon 0
resource "aws_s3_bucket" "tfstate" {
  count = var.cloud_provider == "aws" ? 1 : 0

  # Nom du bucket : portfolio-prod-tfstate
  # Doit être globalement unique dans AWS
  bucket = "${var.project_name}-${var.environment}-tfstate"

  # Tags pour identifier la ressource
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-tfstate"
      Type = "TerraformState"
    }
  )
}

# ----------------------------------------------------------------------------
# RESOURCE: Versioning du bucket S3
# ----------------------------------------------------------------------------
# Garde l'historique de toutes les versions du state
# Si tu casses quelque chose, tu peux revenir en arrière !
resource "aws_s3_bucket_versioning" "tfstate" {
  count = var.cloud_provider == "aws" && var.enable_versioning ? 1 : 0

  bucket = aws_s3_bucket.tfstate[0].id

  versioning_configuration {
    status = "Enabled"  # Active le versioning
  }
}

# ----------------------------------------------------------------------------
# RESOURCE: Chiffrement du bucket S3
# ----------------------------------------------------------------------------
# Chiffre le state au repos avec AES-256
# Sécurité : personne ne peut lire le state sans permissions
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  count = var.cloud_provider == "aws" && var.enable_encryption ? 1 : 0

  bucket = aws_s3_bucket.tfstate[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"  # Algorithme de chiffrement
    }
  }
}

# ----------------------------------------------------------------------------
# RESOURCE: Bloquer l'accès public au bucket
# ----------------------------------------------------------------------------
# Sécurité : le state ne doit JAMAIS être public
# Contient des infos sensibles (IDs de ressources, configs)
resource "aws_s3_bucket_public_access_block" "tfstate" {
  count = var.cloud_provider == "aws" ? 1 : 0

  bucket = aws_s3_bucket.tfstate[0].id

  block_public_acls       = true  # Bloque les ACLs publiques
  block_public_policy     = true  # Bloque les policies publiques
  ignore_public_acls      = true  # Ignore les ACLs publiques existantes
  restrict_public_buckets = true  # Restreint les buckets publics
}

# ----------------------------------------------------------------------------
# RESOURCE: DynamoDB pour le state locking
# ----------------------------------------------------------------------------
# Empêche 2 personnes de modifier le state en même temps
# Imagine : Toi et ton collègue faites "terraform apply" en même temps
# → Sans lock : CHAOS, state corrompu
# → Avec lock : Le 2e doit attendre que le 1er ait fini
resource "aws_dynamodb_table" "tfstate_lock" {
  count = var.cloud_provider == "aws" ? 1 : 0

  name         = "${var.project_name}-${var.environment}-tfstate-lock"
  billing_mode = "PAY_PER_REQUEST"  # Paiement à l'usage (pas de provisioning)
  hash_key     = "LockID"           # Clé primaire (requis par Terraform)

  # Attribut LockID (type String)
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-tfstate-lock"
      Type = "TerraformStateLock"
    }
  )
}

# ============================================================================
# PARTIE 2 : BACKEND GCP (Google Cloud Storage)
# ============================================================================

# ----------------------------------------------------------------------------
# RESOURCE: GCS Bucket pour stocker le state
# ----------------------------------------------------------------------------
# Créé SEULEMENT si cloud_provider = "gcp"
resource "google_storage_bucket" "tfstate" {
  count = var.cloud_provider == "gcp" ? 1 : 0

  name     = "${var.project_name}-${var.environment}-tfstate"
  location = var.gcp_region
  project  = var.gcp_project_id

  # Empêche la suppression accidentelle du bucket
  force_destroy = false

  # Versioning (historique des états)
  versioning {
    enabled = var.enable_versioning
  }

  # Chiffrement par défaut de GCP (automatiquement activé)
  # Pas besoin de bloc encryption {} pour utiliser le chiffrement par défaut

  # Accès uniforme (simplifie la gestion des permissions)
  uniform_bucket_level_access = true

  # Labels (équivalent des tags AWS)
  labels = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
    type        = "terraform-state"
  }
}

# ----------------------------------------------------------------------------
# RESOURCE: IAM pour bloquer l'accès public au bucket GCP
# ----------------------------------------------------------------------------
# Sécurité : le bucket ne doit pas être accessible publiquement
resource "google_storage_bucket_iam_member" "prevent_public_access" {
  count = var.cloud_provider == "gcp" ? 1 : 0

  bucket = google_storage_bucket.tfstate[0].name
  role   = "roles/storage.admin"
  member = "projectEditor:${var.gcp_project_id}"
}

# ============================================================================
# PARTIE 3 : LOCALS (Variables calculées)
# ============================================================================

# Variables locales pour simplifier les outputs
locals {
  # Nom du bucket (AWS ou GCP selon le provider)
  bucket_name = var.cloud_provider == "aws" ? (
    length(aws_s3_bucket.tfstate) > 0 ? aws_s3_bucket.tfstate[0].id : ""
  ) : (
    length(google_storage_bucket.tfstate) > 0 ? google_storage_bucket.tfstate[0].name : ""
  )

  # URL du bucket
  bucket_url = var.cloud_provider == "aws" ? (
    length(aws_s3_bucket.tfstate) > 0 ? "s3://${aws_s3_bucket.tfstate[0].bucket}" : ""
  ) : (
    length(google_storage_bucket.tfstate) > 0 ? "gs://${google_storage_bucket.tfstate[0].name}" : ""
  )

  # Nom de la table DynamoDB (seulement pour AWS)
  dynamodb_table = var.cloud_provider == "aws" && length(aws_dynamodb_table.tfstate_lock) > 0 ? (
    aws_dynamodb_table.tfstate_lock[0].name
  ) : null
}
