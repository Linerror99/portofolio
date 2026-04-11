# Module Monitoring GCP

Module Terraform pour le monitoring complet des services Cloud Run sur GCP.

## Fonctionnalités

### Uptime Checks
- Vérification HTTPS toutes les 5 minutes pour chaque URL
- Alerte immédiate si un site est down (5 min de vérification)
- Surveillance de l'expiration des certificats SSL (< 15 jours)

### Alerting Policies (7 alertes)
| Alerte | Seuil par défaut | Sévérité |
|--------|------------------|----------|
| High Latency (p99) | > 5000ms | warning |
| High Error Rate (5xx) | > 5% | critical |
| High CPU | > 80% | warning |
| High Memory | > 80% | warning |
| Request Spike | > 500 req/min | critical |
| Instance Count | > 5 instances | warning |
| Suspicious Requests | > 10 req/5min | high |

### Log-based Metrics
- **4xx errors** : erreurs client (bad requests, not found, etc.)
- **5xx errors** : erreurs serveur
- **Suspicious requests** : requêtes vers des paths d'attaque connus (`/wp-admin`, `/.env`, `/phpmyadmin`, etc.) avec extraction IP source

### Dashboard
Dashboard complet avec 5 sections :
1. **Uptime** : scorecards de disponibilité par site
2. **Requêtes** : volume de requêtes et taux d'erreurs
3. **Latence** : p50, p95, p99 et nombre d'instances
4. **Ressources** : CPU et mémoire
5. **Sécurité** : requêtes suspectes

## Prérequis

```bash
# Activer les APIs nécessaires
gcloud services enable monitoring.googleapis.com --project=<PROJECT_ID>
gcloud services enable logging.googleapis.com --project=<PROJECT_ID>
```

## Utilisation

```hcl
module "monitoring" {
  source = "../../modules/monitoring"

  gcp_project_id = "my-project-id"
  gcp_region     = "us-west1"
  project_name   = "portfolio"
  environment    = "prod"

  notification_email     = "alerts@example.com"
  cloud_run_service_name = module.compute.cloud_run_service_name

  monitored_urls = [
    {
      display_name = "Portfolio"
      host         = "ldjossou.com"
      path         = "/"
    }
  ]
}
```

## Variables

| Variable | Description | Défaut |
|----------|-------------|--------|
| `gcp_project_id` | ID du projet GCP | - (requis) |
| `notification_email` | Email pour les alertes | - (requis) |
| `monitored_urls` | URLs à monitorer | `[]` |
| `cloud_run_service_name` | Nom du service Cloud Run | `""` |
| `latency_threshold_ms` | Seuil latence p99 (ms) | `5000` |
| `error_rate_threshold` | Seuil taux d'erreur (0-1) | `0.05` |
| `cpu_threshold` | Seuil CPU (0-1) | `0.8` |
| `memory_threshold` | Seuil mémoire (0-1) | `0.8` |
| `request_count_spike_threshold` | Seuil requêtes/min | `500` |
| `instance_count_threshold` | Seuil instances | `5` |
| `suspicious_paths` | Paths d'attaque à surveiller | voir variables.tf |

## Outputs

| Output | Description |
|--------|-------------|
| `dashboard_url` | URL directe du dashboard |
| `monitoring_console_urls` | URLs utiles (alertes, uptime, métriques) |
| `alert_policy_ids` | IDs des politiques d'alerte |
| `uptime_check_ids` | IDs des uptime checks |
| `log_metric_names` | Noms des métriques log-based |

## Recommandations supplémentaires

### Cloudflare WAF (fortement recommandé)
En complément du monitoring, configurer sur Cloudflare :
1. **Rate Limiting** : limiter à 100 req/10s par IP
2. **WAF Rules** : activer les règles OWASP
3. **Bot Fight Mode** : activer dans Security > Bots
4. **IP Access Rules** : bloquer les IPs malveillantes détectées

### Commandes utiles
```bash
# Voir les alertes actives
gcloud alpha monitoring policies list --project=<PROJECT_ID> --filter="enabled=true"

# Voir les incidents en cours
gcloud alpha monitoring incidents list --project=<PROJECT_ID>

# Voir les logs de requêtes suspectes
gcloud logging read 'resource.type="cloud_run_revision" AND httpRequest.requestUrl=~"wp-admin|phpmyadmin|\.env"' --limit=50 --project=<PROJECT_ID>
```
