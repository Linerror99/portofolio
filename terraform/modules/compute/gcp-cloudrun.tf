# ============================================================================
# PARTIE 8 : GOOGLE CLOUD RUN - GCP
# ============================================================================

# ----------------------------------------------------------------------------
# RESOURCE: Cloud Run Service
# ----------------------------------------------------------------------------
# Service serverless qui héberge l'application containerisée
resource "google_cloud_run_v2_service" "app" {
  count = var.cloud_provider == "gcp" ? 1 : 0

  name     = "${var.project_name}-${var.environment}-${var.app_name}"
  location = var.gcp_region
  project  = var.gcp_project_id

  template {
    # Configuration du conteneur
    containers {
      image = var.container_image

      # Resources (CPU et mémoire)
      resources {
        limits = {
          cpu    = "1"           # 1 vCPU
          memory = "${var.memory}Mi"  # 512Mi
        }
      }

      # Port exposé
      ports {
        container_port = var.container_port
      }

      # Variables d'environnement
      env {
        name  = "NODE_ENV"
        value = "production"
      }
      
      env {
        name  = "PORT"
        value = tostring(var.container_port)
      }

      # Health check
      liveness_probe {
        http_get {
          path = var.health_check_path
          port = var.container_port
        }
        initial_delay_seconds = 30
        timeout_seconds       = 5
        period_seconds        = 30
        failure_threshold     = 3
      }

      startup_probe {
        http_get {
          path = var.health_check_path
          port = var.container_port
        }
        initial_delay_seconds = 10
        timeout_seconds       = 5
        period_seconds        = 10
        failure_threshold     = 10
      }
    }

    # Configuration du scaling
    scaling {
      min_instance_count = var.desired_count
      max_instance_count = var.enable_autoscaling ? var.max_capacity : var.desired_count
    }

    # Configuration de l'exécution
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"  # Génération 2 (plus rapide)
    timeout              = "300s"  # 5 minutes max par requête
    
    # Configuration VPC (optionnel, pour l'instant on reste public)
    # vpc_access {
    #   connector = google_vpc_access_connector.connector[0].id
    # }
  }

  # Trafic : 100% vers la dernière révision
  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  labels = {
    project     = var.project_name
    environment = var.environment
    app         = var.app_name
    managed_by  = "terraform"
  }
}

# ----------------------------------------------------------------------------
# RESOURCE: IAM Policy pour accès public
# ----------------------------------------------------------------------------
# Permet l'accès sans authentification (portfolio public)
resource "google_cloud_run_service_iam_member" "public_access" {
  count = var.cloud_provider == "gcp" && var.allow_unauthenticated ? 1 : 0

  location = google_cloud_run_v2_service.app[0].location
  project  = google_cloud_run_v2_service.app[0].project
  service  = google_cloud_run_v2_service.app[0].name
  role     = "roles/run.invoker"
  member   = "allUsers"  # Accès public
}

# ============================================================================
# PARTIE 9 : LOAD BALANCER + SSL (OPTIONNEL) - GCP
# ============================================================================

# ----------------------------------------------------------------------------
# RESOURCE: Backend Service
# ----------------------------------------------------------------------------
# Backend qui pointe vers Cloud Run (pour Load Balancer global)
resource "google_compute_backend_service" "app" {
  count = var.cloud_provider == "gcp" && var.domain_name != "" ? 1 : 0

  name        = "${var.project_name}-${var.environment}-backend"
  project     = var.gcp_project_id
  description = "Backend service pour ${var.project_name}"

  backend {
    group = google_compute_region_network_endpoint_group.app[0].id
  }

  # Configuration health check
  health_checks = [google_compute_health_check.app[0].id]

  # Configuration du load balancing
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol             = "HTTP"
  timeout_sec          = 30
}

# ----------------------------------------------------------------------------
# RESOURCE: Network Endpoint Group
# ----------------------------------------------------------------------------
# Groupe d'endpoints qui pointe vers Cloud Run
resource "google_compute_region_network_endpoint_group" "app" {
  count = var.cloud_provider == "gcp" && var.domain_name != "" ? 1 : 0

  name                  = "${var.project_name}-${var.environment}-neg"
  project               = var.gcp_project_id
  region                = var.gcp_region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = google_cloud_run_v2_service.app[0].name
  }
}

# ----------------------------------------------------------------------------
# RESOURCE: Health Check
# ----------------------------------------------------------------------------
resource "google_compute_health_check" "app" {
  count = var.cloud_provider == "gcp" && var.domain_name != "" ? 1 : 0

  name    = "${var.project_name}-${var.environment}-health-check"
  project = var.gcp_project_id

  http_health_check {
    request_path = var.health_check_path
    port         = var.container_port
  }

  check_interval_sec  = 30
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3
}

# ----------------------------------------------------------------------------
# RESOURCE: URL Map
# ----------------------------------------------------------------------------
resource "google_compute_url_map" "app" {
  count = var.cloud_provider == "gcp" && var.domain_name != "" ? 1 : 0

  name            = "${var.project_name}-${var.environment}-url-map"
  project         = var.gcp_project_id
  default_service = google_compute_backend_service.app[0].id
}

# ----------------------------------------------------------------------------
# RESOURCE: SSL Certificate
# ----------------------------------------------------------------------------
resource "google_compute_managed_ssl_certificate" "app" {
  count = var.cloud_provider == "gcp" && var.domain_name != "" && var.create_certificate ? 1 : 0

  name    = "${var.project_name}-${var.environment}-ssl-cert"
  project = var.gcp_project_id

  managed {
    domains = [var.domain_name]
  }
}

# ----------------------------------------------------------------------------
# RESOURCE: HTTPS Proxy
# ----------------------------------------------------------------------------
resource "google_compute_target_https_proxy" "app" {
  count = var.cloud_provider == "gcp" && var.domain_name != "" && var.create_certificate ? 1 : 0

  name             = "${var.project_name}-${var.environment}-https-proxy"
  project          = var.gcp_project_id
  url_map          = google_compute_url_map.app[0].id
  ssl_certificates = [google_compute_managed_ssl_certificate.app[0].id]
}

# ----------------------------------------------------------------------------
# RESOURCE: HTTP Proxy (redirect vers HTTPS)
# ----------------------------------------------------------------------------
resource "google_compute_target_http_proxy" "app" {
  count = var.cloud_provider == "gcp" && var.domain_name != "" ? 1 : 0

  name    = "${var.project_name}-${var.environment}-http-proxy"
  project = var.gcp_project_id
  url_map = google_compute_url_map.app[0].id
}

# ----------------------------------------------------------------------------
# RESOURCE: Global Forwarding Rules
# ----------------------------------------------------------------------------
# Forwarding rule pour HTTPS (443)
resource "google_compute_global_forwarding_rule" "https" {
  count = var.cloud_provider == "gcp" && var.domain_name != "" && var.create_certificate ? 1 : 0

  name       = "${var.project_name}-${var.environment}-https-rule"
  project    = var.gcp_project_id
  target     = google_compute_target_https_proxy.app[0].id
  port_range = "443"
  ip_address = google_compute_global_address.app[0].id
}

# Forwarding rule pour HTTP (80) - redirect vers HTTPS
resource "google_compute_global_forwarding_rule" "http" {
  count = var.cloud_provider == "gcp" && var.domain_name != "" ? 1 : 0

  name       = "${var.project_name}-${var.environment}-http-rule"
  project    = var.gcp_project_id
  target     = google_compute_target_http_proxy.app[0].id
  port_range = "80"
  ip_address = google_compute_global_address.app[0].id
}

# ----------------------------------------------------------------------------
# RESOURCE: Global Static IP
# ----------------------------------------------------------------------------
resource "google_compute_global_address" "app" {
  count = var.cloud_provider == "gcp" && var.domain_name != "" ? 1 : 0

  name    = "${var.project_name}-${var.environment}-ip"
  project = var.gcp_project_id
}