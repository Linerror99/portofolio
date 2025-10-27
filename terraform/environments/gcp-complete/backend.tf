# ============================================================================
# BACKEND CONFIGURATION - GCS Remote State
# ============================================================================
# Ce fichier configure le backend remote sur Google Cloud Storage
# L'état Terraform sera stocké dans le bucket GCS créé par le module backend

terraform {
  backend "gcs" {
    bucket = "portfolio-prod-tfstate"
    prefix = "gcp-complete/terraform.tfstate"
    # Les autres options sont automatiquement détectées :
    # - project: portfolio-test-476200 (via gcloud config)
    # - location: us-west1 (région du bucket)
  }
}
