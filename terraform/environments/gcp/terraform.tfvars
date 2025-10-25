# ============================================================================
# Configuration GCP pour le Backend State
# ============================================================================

project_name      = "portfolio"
environment       = "prod"
gcp_project_id    = "portfolio-test-476200"  # ID du projet GCP
gcp_region        = "us-west1"
enable_versioning = true
enable_encryption = true

tags = {
  owner       = "ldjossou"
  purpose     = "backend-state-storage"
  cost_center = "portfolio"
}
