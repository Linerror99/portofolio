# Module Compute - Déploiement Multi-Cloud

Ce module Terraform déploie l'application de portfolio sur AWS (ECS Fargate) ou GCP (Cloud Run) avec des URLs professionnelles et un support SSL complet.

## 🎯 Objectifs du Module

- **URLs Professionnelles** : Utilise des domaines custom au lieu des URLs par défaut des cloud providers
- **Multi-Cloud** : Un seul module pour AWS et GCP
- **SSL/HTTPS** : Certificats SSL automatiques avec Let's Encrypt
- **Autoscaling** : Configuration automatique du scaling selon la charge
- **Monitoring** : Logs et health checks intégrés

## 🏗️ Architecture

### AWS (ECS Fargate)
```
Internet → Route 53 → ALB → ECS Fargate Service → Container
         ↓         ↓    ↓                    ↓
      SSL Cert  VPC+Subnets  CloudWatch    Registry
```

### GCP (Cloud Run)
```
Internet → Cloud DNS → Global Load Balancer → Cloud Run Service → Container
         ↓           ↓                      ↓                  ↓
      SSL Cert   Static IP            Cloud Logging      Registry
```

## 📋 Prérequis

### Communs
- Terraform >= 1.5
- Image Docker disponible dans un registry
- Domaine DNS (optionnel, mais recommandé)

### AWS
- AWS CLI configuré
- Permissions : ECS, ALB, VPC, Route53, Certificate Manager
- Provider AWS configuré

### GCP
- `gcloud` CLI configuré
- APIs activées : Cloud Run, Compute Engine, Certificate Manager
- Provider GCP configuré

## 🔧 Variables

### Variables Obligatoires

| Variable | Type | Description | Exemple |
|----------|------|-------------|---------|
| `cloud_provider` | string | Provider cloud ("aws" ou "gcp") | "aws" |
| `project_name` | string | Nom du projet | "portfolio" |
| `environment` | string | Environnement | "prod" |
| `container_image` | string | Image Docker complète | "123456789012.dkr.ecr.us-west-1.amazonaws.com/portfolio:latest" |

### Variables AWS

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `region` | string | "us-west-1" | Région AWS |
| `availability_zones` | list(string) | ["us-west-1a", "us-west-1b"] | Zones de disponibilité |

### Variables GCP

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `gcp_project_id` | string | - | ID du projet GCP |
| `gcp_region` | string | "us-west1" | Région GCP |

### Variables de Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `domain_name` | string | "" | Domaine custom (ex: portfolio.ldjossou.dev) |
| `cpu` | string | "256" | CPU alloué (AWS: 256/512/1024, GCP: "1") |
| `memory` | string | "512" | Mémoire en MB (AWS: 512/1024/2048, GCP: "2Gi") |
| `container_port` | number | 80 | Port du container |
| `desired_count` | number | 2 | Nombre d'instances |
| `enable_autoscaling` | bool | true | Activer l'autoscaling |
| `min_capacity` | number | 1 | Capacité minimale |
| `max_capacity` | number | 10 | Capacité maximale |

## 🚀 Utilisation

### Déploiement AWS basique

```hcl
module "compute" {
  source = "../modules/compute"
  
  cloud_provider   = "aws"
  project_name     = "portfolio"
  environment      = "prod"
  container_image  = "123456789012.dkr.ecr.us-west-1.amazonaws.com/portfolio:latest"
  
  # Configuration AWS
  region              = "us-west-1"
  availability_zones  = ["us-west-1a", "us-west-1b"]
  
  # Ressources
  cpu             = "256"
  memory          = "512"
  desired_count   = 2
}
```

### Déploiement AWS avec domaine custom

```hcl
module "compute" {
  source = "../modules/compute"
  
  cloud_provider   = "aws"
  project_name     = "portfolio"
  environment      = "prod"
  container_image  = "123456789012.dkr.ecr.us-west-1.amazonaws.com/portfolio:latest"
  domain_name      = "portfolio.ldjossou.dev"
  
  # Configuration AWS
  region              = "us-west-1"
  availability_zones  = ["us-west-1a", "us-west-1b"]
  
  # Ressources avec autoscaling
  cpu               = "512"
  memory            = "1024"
  desired_count     = 2
  enable_autoscaling = true
  min_capacity      = 1
  max_capacity      = 5
}
```

### Déploiement GCP basique

```hcl
module "compute" {
  source = "../modules/compute"
  
  cloud_provider   = "gcp"
  project_name     = "portfolio"
  environment      = "prod"
  container_image  = "us-west1-docker.pkg.dev/mon-projet/portfolio/app:latest"
  
  # Configuration GCP
  gcp_project_id  = "mon-projet-gcp-123"
  gcp_region      = "us-west1"
  
  # Ressources
  cpu             = "1"
  memory          = "2Gi"
  desired_count   = 2
}
```

### Déploiement GCP avec domaine custom

```hcl
module "compute" {
  source = "../modules/compute"
  
  cloud_provider   = "gcp"
  project_name     = "portfolio"
  environment      = "prod"
  container_image  = "us-west1-docker.pkg.dev/mon-projet/portfolio/app:latest"
  domain_name      = "portfolio.ldjossou.dev"
  
  # Configuration GCP
  gcp_project_id  = "mon-projet-gcp-123"
  gcp_region      = "us-west1"
  
  # Ressources avec autoscaling
  cpu               = "2"
  memory            = "4Gi"
  desired_count     = 2
  enable_autoscaling = true
  min_capacity      = 1
  max_capacity      = 10
}
```

## 📊 Outputs

### URLs d'accès

| Output | Description | Exemple |
|--------|-------------|---------|
| `app_url` | URL principale de l'application | https://portfolio.ldjossou.dev |
| `load_balancer_dns` | DNS du load balancer AWS | portfolio-prod-alb-123.us-west-1.elb.amazonaws.com |
| `cloud_run_url` | URL du service Cloud Run | https://portfolio-prod-abc123-uw.a.run.app |
| `health_check_url` | URL du health check | https://portfolio.ldjossou.dev/ |

### Configuration DNS

| Output | Description |
|--------|-------------|
| `dns_configuration` | Instructions pour configurer le DNS |
| `static_ip` | IP statique (GCP uniquement) |

### Monitoring

| Output | Description |
|--------|-------------|
| `logs_urls` | URLs vers les logs cloud |
| `autoscaling_config` | Configuration de l'autoscaling |

## 🌐 Configuration DNS

### Avec domaine custom

Après le déploiement, configurez votre DNS :

**AWS (enregistrement CNAME)** :
```
portfolio.ldjossou.dev → portfolio-prod-alb-123456789.us-west-1.elb.amazonaws.com
```

**GCP (enregistrement A)** :
```
portfolio.ldjossou.dev → 34.102.136.180
```

### Sans domaine custom

Le module utilise les URLs par défaut des providers :
- **AWS** : `http://portfolio-prod-alb-123.us-west-1.elb.amazonaws.com`
- **GCP** : `https://portfolio-prod-abc123-uw.a.run.app`

## 🔍 Monitoring et Logs

### AWS CloudWatch
- **Logs** : `/ecs/portfolio-prod`
- **Métriques** : CPU, Memory, Task Count
- **Alarms** : CPU > 80%, Memory > 80%

### GCP Cloud Logging
- **Logs** : Automatiquement collectés dans Cloud Logging
- **Métriques** : CPU, Memory, Request Count
- **Alerting** : Configurable via Cloud Monitoring

## 🔄 Autoscaling

### AWS (ECS)
- **Target Tracking** : CPU à 70%
- **Scale Out** : +50% des instances si CPU > 70% pendant 2 min
- **Scale In** : -50% des instances si CPU < 70% pendant 5 min

### GCP (Cloud Run)
- **Concurrency** : 80 requêtes par instance
- **Scale to Zero** : Instances supprimées si pas de trafic
- **Cold Start** : < 1 seconde pour démarrer une instance

## 🔒 Sécurité

### Réseau
- **AWS** : VPC isolé, subnets privés, NAT Gateway
- **GCP** : Réseau managed, traffic HTTPS uniquement

### SSL/TLS
- **AWS** : Certificate Manager avec validation DNS
- **GCP** : Google-managed SSL certificates
- **Redirection** : HTTP → HTTPS automatique

### Accès
- **AWS** : Security Groups restrictifs (port 80/443 uniquement)
- **GCP** : IAM roles minimum, traffic Internet uniquement

## 🧪 Testing

### Test de santé

```bash
# Test du health check
curl -f https://portfolio.ldjossou.dev/

# Test avec domaine par défaut
# AWS
curl -f http://portfolio-prod-alb-123.us-west-1.elb.amazonaws.com/
# GCP  
curl -f https://portfolio-prod-abc123-uw.a.run.app/
```

### Test de performance

```bash
# Test de charge basique
for i in {1..10}; do
  curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" https://portfolio.ldjossou.dev/
done
```

## 🛠️ Maintenance

### Mise à jour de l'image

```bash
# 1. Build et push nouvelle image
docker build -t portfolio:v2.0 .
docker tag portfolio:v2.0 123456789012.dkr.ecr.us-west-1.amazonaws.com/portfolio:v2.0
docker push 123456789012.dkr.ecr.us-west-1.amazonaws.com/portfolio:v2.0

# 2. Mise à jour Terraform
terraform plan -var="container_image=123456789012.dkr.ecr.us-west-1.amazonaws.com/portfolio:v2.0"
terraform apply
```

### Rollback

```bash
# Retour à la version précédente
terraform plan -var="container_image=123456789012.dkr.ecr.us-west-1.amazonaws.com/portfolio:v1.9"
terraform apply
```

## 🐛 Troubleshooting

### Problèmes courants

#### Application non accessible

**AWS** :
```bash
# Vérifier le service ECS
aws ecs describe-services --cluster portfolio-prod --services portfolio-prod-app

# Vérifier l'ALB
aws elbv2 describe-load-balancers --names portfolio-prod-alb

# Vérifier les logs
aws logs tail /ecs/portfolio-prod --follow
```

**GCP** :
```bash
# Vérifier le service Cloud Run
gcloud run services describe portfolio-prod-app --region=us-west1

# Vérifier les logs
gcloud logs read "resource.type=cloud_run_revision" --limit=50
```

#### Problèmes SSL

**AWS** :
- Vérifier que le certificat est validé dans Certificate Manager
- Confirmer l'enregistrement DNS CNAME

**GCP** :
- Vérifier que l'IP statique est configurée dans le DNS
- Attendre jusqu'à 24h pour la propagation SSL

#### Performance

```bash
# Vérifier les métriques d'autoscaling
# AWS
aws application-autoscaling describe-scaling-activities --service-namespace ecs

# GCP
gcloud logging read "resource.type=cloud_run_revision" --filter="severity=INFO"
```

## 📚 Ressources

- [AWS ECS Fargate](https://docs.aws.amazon.com/ecs/latest/userguide/what-is-fargate.html)
- [GCP Cloud Run](https://cloud.google.com/run/docs)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

---

**Version** : 1.0  
**Auteur** : Louis-Dany Jossou  
**Dernière mise à jour** : 2024-12-19