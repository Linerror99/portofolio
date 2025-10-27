# 🚀 CI/CD Smart Resource Management

## 📋 Stratégie de Déploiement Intelligent

### 🎯 Principe
- **`develop` branch** → AWS ECS Fargate (Staging) 
- **`main` branch** → GCP Cloud Run (Production) + Arrêt AWS (économie)
- **Un seul environnement actif** à la fois pour optimiser les coûts

### 💰 Économies
| État | AWS | GCP | Coût/mois |
|------|-----|-----|-----------|
| develop active | ✅ ON | ❌ OFF | ~65€ |
| main active | ❌ OFF | ✅ ON | ~15€ |
| idle | ❌ OFF | ❌ OFF | ~2€ |

### 🔄 Workflows

#### 1. `staging-aws.yml` (develop branch)
- **Trigger** : Push sur `develop`
- **Action** : Deploy AWS ECS Fargate
- **Économie** : N/A (environnement de staging)

#### 2. `production-gcp.yml` (main branch)  
- **Trigger** : Push sur `main`
- **Action 1** : Stop AWS ECS (scale to 0)
- **Action 2** : Deploy GCP Cloud Run
- **Économie** : ~50€/mois

### ⚙️ Configuration requise

#### GitHub Secrets
```bash
# AWS
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY  
AWS_REGION=us-west-1

# GCP
GCP_PROJECT_ID=portfolio-test-476200
GCP_SERVICE_ACCOUNT_KEY

# Registries
ECR_REPOSITORY=xxx.dkr.ecr.us-west-1.amazonaws.com/portfolio-prod-app
GCP_ARTIFACT_REGISTRY=us-west1-docker.pkg.dev/portfolio-test-476200/portfolio-prod-app
```