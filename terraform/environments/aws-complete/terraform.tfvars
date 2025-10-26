# ============================================================================
# VARIABLES DE CONFIGURATION - AWS COMPLETE
# ============================================================================

# ----------------------------------------------------------------------------
# CONFIGURATION GÉNÉRALE
# ----------------------------------------------------------------------------
project_name = "portfolio"
environment  = "prod"
region       = "us-west-1"

# ----------------------------------------------------------------------------
# CONFIGURATION DOMAINE ET HTTPS 🌐
# ----------------------------------------------------------------------------
domain_name         = "ldjossou.com"       # Votre nouveau domaine !
create_route53_zone = true                 # Créer la zone Route 53
enable_https        = false                # HTTPS désactivé temporairement (le temps que le domaine se propage)

# ----------------------------------------------------------------------------
# TAGS COMMUNS
# ----------------------------------------------------------------------------
tags = {
  Owner      = "LDjossou"
  Project    = "Portfolio"
  ManagedBy  = "Terraform"
  CostCenter = "Portfolio"
  Domain     = "ldjossou.com"
}