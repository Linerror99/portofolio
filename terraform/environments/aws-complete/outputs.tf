# ============================================================================
# OUTPUTS - AWS COMPLETE ENVIRONMENT
# ============================================================================

# Backend State
output "s3_bucket_name" {
  description = "Nom du bucket S3 pour le state Terraform"
  value       = module.backend.bucket_name
}

output "dynamodb_table_name" {
  description = "Nom de la table DynamoDB pour le locking"
  value       = module.backend.dynamodb_table
}

# Container Registry
output "ecr_repository_url" {
  description = "URL du repository ECR"
  value       = module.container_registry.registry_url
}

# Compute
output "load_balancer_dns" {
  description = "DNS name du load balancer"
  value       = module.compute.load_balancer_dns
}

output "load_balancer_url" {
  description = "URL complète du load balancer"
  value       = "http://${module.compute.load_balancer_dns}"
}

# Route 53 DNS
output "route53_zone_id" {
  description = "ID de la zone Route 53"
  value       = var.create_route53_zone && var.domain_name != "" ? aws_route53_zone.main[0].zone_id : null
}

output "route53_name_servers" {
  description = "Name servers de la zone Route 53 (à configurer chez le registraire)"
  value       = var.create_route53_zone && var.domain_name != "" ? aws_route53_zone.main[0].name_servers : []
}

output "domain_urls" {
  description = "URLs du domaine personnalisé"
  value = var.domain_name != "" ? {
    main = var.enable_https ? "https://${var.domain_name}" : "http://${var.domain_name}"
    www  = var.enable_https ? "https://www.${var.domain_name}" : "http://www.${var.domain_name}"
  } : null
}