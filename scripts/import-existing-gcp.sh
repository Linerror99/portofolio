#!/bin/bash
# ============================================================================
# IMPORT EXISTING GCP RESOURCES
# ============================================================================
# Ce script importe automatiquement les ressources GCP existantes dans l'état Terraform
# pour éviter les erreurs "resource already exists"

set -e

echo "🔍 Importing existing GCP resources into Terraform state..."

# Couleurs pour l'affichage
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
PROJECT_ID="portfolio-test-476200"
REGION="us-west1"

# ============================================================================
# FONCTION: Import avec gestion d'erreur
# ============================================================================
import_resource() {
    local resource_address=$1
    local resource_id=$2
    
    echo -n "  Importing $resource_address... "
    
    if terraform import -input=false "$resource_address" "$resource_id" 2>&1 | grep -q "Resource already managed"; then
        echo -e "${GREEN}✓ Already imported${NC}"
        return 0
    elif terraform import -input=false "$resource_address" "$resource_id" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Imported${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ Not found or error (will be created)${NC}"
        return 0
    fi
}

# ============================================================================
# BACKEND: GCS Bucket
# ============================================================================
echo "📦 Backend resources..."
import_resource \
    "module.backend.google_storage_bucket.tfstate[0]" \
    "portfolio-prod-tfstate"

# ============================================================================
# CONTAINER REGISTRY: Artifact Registry
# ============================================================================
echo "🐳 Container registry..."
import_resource \
    "module.container_registry.google_artifact_registry_repository.main[0]" \
    "projects/$PROJECT_ID/locations/$REGION/repositories/portfolio-prod-app"

# ============================================================================
# COMPUTE: Cloud Run Service
# ============================================================================
echo "🚀 Cloud Run service..."
import_resource \
    "module.compute.google_cloud_run_v2_service.app[0]" \
    "projects/$PROJECT_ID/locations/$REGION/services/portfolio-prod-portfolio-app"

# ============================================================================
# IAM: Cloud Run Public Access
# ============================================================================
echo "🔐 IAM permissions..."
import_resource \
    "module.compute.google_cloud_run_service_iam_member.public_access[0]" \
    "projects/$PROJECT_ID/locations/$REGION/services/portfolio-prod-portfolio-app roles/run.invoker allUsers"

echo ""
echo -e "${GREEN}✅ Import completed successfully!${NC}"
echo "📊 Run 'terraform plan' to verify state"