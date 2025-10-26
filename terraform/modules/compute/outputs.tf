# ============================================================================
# MODULE: Compute - Outputs
# ============================================================================

# ============================================================================
# OUTPUTS GÉNÉRIQUES (AWS + GCP)
# ============================================================================

# ----------------------------------------------------------------------------
# OUTPUT: URL de l'application
# ----------------------------------------------------------------------------
output "app_url" {
  description = "URL pour accéder à l'application"
  value = var.cloud_provider == "aws" ? (
    var.domain_name != "" ? "https://${var.domain_name}" : "http://${aws_lb.main[0].dns_name}"
  ) : (
    var.domain_name != "" ? "https://${var.domain_name}" : google_cloud_run_v2_service.app[0].uri
  )
  # AWS avec domaine : https://portfolio.ldjossou.dev
  # AWS sans domaine : http://portfolio-prod-alb-123456789.us-west-1.elb.amazonaws.com
  # GCP avec domaine : https://portfolio.ldjossou.dev
  # GCP sans domaine : https://portfolio-prod-app-abc123-uw.a.run.app
}

# ----------------------------------------------------------------------------
# OUTPUT: Load Balancer DNS (AWS uniquement)
# ----------------------------------------------------------------------------
output "load_balancer_dns" {
  description = "DNS du load balancer AWS (null pour GCP)"
  value       = var.cloud_provider == "aws" && length(aws_lb.main) > 0 ? aws_lb.main[0].dns_name : null
  # AWS : portfolio-prod-alb-123456789.us-west-1.elb.amazonaws.com
  # GCP : null
}

# ----------------------------------------------------------------------------
# OUTPUT: Cloud Run URL (GCP uniquement)
# ----------------------------------------------------------------------------
output "cloud_run_url" {
  description = "URL du service Cloud Run (null pour AWS)"
  value       = var.cloud_provider == "gcp" && length(google_cloud_run_v2_service.app) > 0 ? google_cloud_run_v2_service.app[0].uri : null
  # GCP : https://portfolio-prod-app-abc123-uw.a.run.app
  # AWS : null
}

# ----------------------------------------------------------------------------
# OUTPUT: Statique IP (GCP avec domaine uniquement)
# ----------------------------------------------------------------------------
output "static_ip" {
  description = "IP statique pour le domaine custom (GCP uniquement)"
  value = var.cloud_provider == "gcp" && var.domain_name != "" && length(google_compute_global_address.app) > 0 ? (
    google_compute_global_address.app[0].address
  ) : null
  # GCP avec domaine : 34.102.136.180
  # AWS ou GCP sans domaine : null
}

# ============================================================================
# OUTPUTS DÉTAILLÉS POUR DEBUG
# ============================================================================

# ----------------------------------------------------------------------------
# OUTPUT: Service Name
# ----------------------------------------------------------------------------
output "service_name" {
  description = "Nom du service déployé"
  value = var.cloud_provider == "aws" ? (
    length(aws_ecs_service.app) > 0 ? aws_ecs_service.app[0].name : ""
  ) : (
    length(google_cloud_run_v2_service.app) > 0 ? google_cloud_run_v2_service.app[0].name : ""
  )
}

# ----------------------------------------------------------------------------
# OUTPUT: Container Image utilisée
# ----------------------------------------------------------------------------
output "container_image" {
  description = "Image Docker utilisée"
  value       = var.container_image
}

# ----------------------------------------------------------------------------
# OUTPUT: Region
# ----------------------------------------------------------------------------
output "region" {
  description = "Région de déploiement"
  value       = var.cloud_provider == "aws" ? var.region : var.gcp_region
}

# ----------------------------------------------------------------------------
# OUTPUT: Environment
# ----------------------------------------------------------------------------
output "environment" {
  description = "Environnement de déploiement"
  value       = var.environment
}

# ============================================================================
# OUTPUTS POUR LA CONFIGURATION DNS
# ============================================================================

# ----------------------------------------------------------------------------
# OUTPUT: DNS Configuration (instructions)
# ----------------------------------------------------------------------------
output "dns_configuration" {
  description = "Instructions pour configurer le DNS"
  value = var.domain_name != "" ? {
    domain = var.domain_name
    type   = var.cloud_provider == "aws" ? "CNAME" : "A"
    target = var.cloud_provider == "aws" ? (
      length(aws_lb.main) > 0 ? aws_lb.main[0].dns_name : ""
    ) : (
      length(google_compute_global_address.app) > 0 ? google_compute_global_address.app[0].address : ""
    )
    instructions = var.cloud_provider == "aws" ? (
      "Créer un enregistrement CNAME dans votre DNS : ${var.domain_name} → ${length(aws_lb.main) > 0 ? aws_lb.main[0].dns_name : ""}"
    ) : (
      "Créer un enregistrement A dans votre DNS : ${var.domain_name} → ${length(google_compute_global_address.app) > 0 ? google_compute_global_address.app[0].address : ""}"
    )
  } : null
}

# ============================================================================
# OUTPUTS POUR LE MONITORING
# ============================================================================

# ----------------------------------------------------------------------------
# OUTPUT: Health Check URL
# ----------------------------------------------------------------------------
output "health_check_url" {
  description = "URL du health check"
  value = var.cloud_provider == "aws" ? (
    var.domain_name != "" ? "https://${var.domain_name}${var.health_check_path}" : "http://${length(aws_lb.main) > 0 ? aws_lb.main[0].dns_name : ""}${var.health_check_path}"
  ) : (
    var.domain_name != "" ? "https://${var.domain_name}${var.health_check_path}" : "${length(google_cloud_run_v2_service.app) > 0 ? google_cloud_run_v2_service.app[0].uri : ""}${var.health_check_path}"
  )
}

# ----------------------------------------------------------------------------
# OUTPUT: Logs (liens vers les logs)
# ----------------------------------------------------------------------------
output "logs_urls" {
  description = "URLs pour accéder aux logs"
  value = var.cloud_provider == "aws" ? {
    cloudwatch_logs = length(aws_cloudwatch_log_group.app) > 0 ? (
      "https://${var.region}.console.aws.amazon.com/cloudwatch/home?region=${var.region}#logsV2:log-groups/log-group/${replace(aws_cloudwatch_log_group.app[0].name, "/", "$252F")}"
    ) : ""
    ecs_service = length(aws_ecs_service.app) > 0 ? (
      "https://${var.region}.console.aws.amazon.com/ecs/home?region=${var.region}#/clusters/${aws_ecs_cluster.main[0].name}/services/${aws_ecs_service.app[0].name}/details"
    ) : ""
  } : {
    cloud_run_logs = length(google_cloud_run_v2_service.app) > 0 ? (
      "https://console.cloud.google.com/run/detail/${var.gcp_region}/${google_cloud_run_v2_service.app[0].name}/logs?project=${var.gcp_project_id}"
    ) : ""
  }
}

# ============================================================================
# OUTPUTS POUR L'AUTOSCALING (SI ACTIVÉ)
# ============================================================================

# ----------------------------------------------------------------------------
# OUTPUT: Autoscaling Configuration
# ----------------------------------------------------------------------------
output "autoscaling_config" {
  description = "Configuration de l'autoscaling"
  value = var.enable_autoscaling ? {
    enabled      = true
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
    current_desired = var.desired_count
  } : {
    enabled      = false
    min_capacity = var.desired_count
    max_capacity = var.desired_count
    current_desired = var.desired_count
  }
}