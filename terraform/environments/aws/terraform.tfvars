# ============================================================================
# Configuration AWS pour le Backend State
# ============================================================================

project_name      = "portfolio"
environment       = "prod"
region            = "us-west-1"
enable_versioning = true
enable_encryption = true

tags = {
  Owner       = "LDjossou"
  Purpose     = "Backend State Storage"
  CostCenter  = "Portfolio"
}
