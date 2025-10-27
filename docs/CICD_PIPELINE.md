# 🔄 CI/CD Pipeline Multi-Cloud

## Vue d'ensemble

```mermaid
graph LR
    Dev["👨‍💻 Developer"]
    
    subgraph GitHub["🐙 GitHub"]
        Develop["develop branch"]
        Main["main branch"]
    end
    
    subgraph Workflows["⚙️ GitHub Actions"]
        AWS_WF["staging-aws.yml"]
        GCP_WF["production-gcp.yml"]
    end
    
    subgraph Clouds["☁️ Cloud Providers"]
        AWS["AWS Staging<br/>✅ Active"]
        GCP["GCP Production<br/>⚫ Inactive"]
    end
    
    Dev -->|"Push"| Develop
    Dev -->|"Merge"| Main
    Develop --> AWS_WF
    Main --> GCP_WF
    AWS_WF --> AWS
    GCP_WF --> GCP
    GCP_WF -.->|"Stop"| AWS
    
    style GitHub fill:#24292e,stroke:#fff,stroke-width:2px,color:#fff
    style Workflows fill:#2088FF,stroke:#0969DA,stroke-width:2px,color:#fff
    style AWS fill:#FF9900,stroke:#232F3E,stroke-width:2px,color:#000
    style GCP fill:#4285F4,stroke:#0F9D58,stroke-width:2px,color:#fff
```

---

## 🟠 Pipeline AWS Staging (develop branch)

### Workflow: `staging-aws.yml`

```mermaid
graph TD
    Trigger["🎯 Trigger<br/>Push to develop"]
    
    subgraph Build["🔨 Build & Push"]
        B1["Checkout code"]
        B2["Configure AWS"]
        B3["Login to ECR"]
        B4["Build Docker<br/>(multi-stage)"]
        B5["Push to ECR"]
    end
    
    subgraph Deploy["🚀 Deploy AWS"]
        D1["Setup GCP creds<br/>(init only)"]
        D2["Setup Terraform"]
        D3["Run import script<br/>import-existing-aws.sh"]
        D4["Terraform init<br/>(S3 backend)"]
        D5["Terraform plan<br/>desired_count=1"]
        D6["Terraform apply"]
    end
    
    subgraph Validate["✅ Validation"]
        V1["Wait 30s"]
        V2["Health check<br/>curl ALB/health"]
        V3["Success ✓"]
    end
    
    Notify["📢 Notification<br/>Deployment status"]
    
    Trigger --> B1
    B1 --> B2
    B2 --> B3
    B3 --> B4
    B4 --> B5
    B5 --> D1
    D1 --> D2
    D2 --> D3
    D3 --> D4
    D4 --> D5
    D5 --> D6
    D6 --> V1
    V1 --> V2
    V2 --> V3
    V3 --> Notify
    
    style Trigger fill:#10B981,stroke:#059669,stroke-width:2px
    style Build fill:#F59E0B,stroke:#D97706,stroke-width:2px
    style Deploy fill:#3B82F6,stroke:#2563EB,stroke-width:2px
    style Validate fill:#10B981,stroke:#059669,stroke-width:2px
    style Notify fill:#8B5CF6,stroke:#7C3AED,stroke-width:2px
```

### Détails du workflow

```yaml
name: 🚀 Deploy Staging (AWS)

on:
  push:
    branches: [develop]
    paths:
      - 'app/**'
      - 'terraform/**'
      - '.github/workflows/staging-aws.yml'

jobs:
  build-and-push:
    # Build Docker image and push to ECR
    
  deploy-aws:
    # Import existing resources
    # Deploy infrastructure with Terraform
    # Scale ECS to 1 instance
    
  notify:
    # Send deployment notification
```

### Import automatique des ressources

```bash
#!/bin/bash
# import-existing-aws.sh

# Importe les ressources AWS existantes pour éviter les conflits
terraform import module.backend.aws_s3_bucket.tfstate[0] portfolio-prod-tfstate
terraform import module.backend.aws_dynamodb_table.tfstate_lock[0] portfolio-prod-tfstate-lock
terraform import module.container_registry.aws_ecr_repository.main[0] portfolio-prod-app
terraform import module.compute.aws_ecs_cluster.main[0] arn:aws:ecs:...
# ... autres ressources
```

---

## 🔵 Pipeline GCP Production (main branch)

### Workflow: `production-gcp.yml`

```mermaid
graph TD
    Trigger["🎯 Trigger<br/>Push to main"]
    
    subgraph StopAWS["🛑 Stop AWS (Parallel)"]
        S1["Configure AWS"]
        S2["Setup Terraform"]
        S3["Terraform apply<br/>desired_count=0"]
        S4["💰 Save ~50€/month"]
    end
    
    subgraph BuildGCP["🔨 Build & Push"]
        B1["Checkout code"]
        B2["Auth to GCP"]
        B3["Setup gcloud"]
        B4["Build Docker"]
        B5["Push to Artifact<br/>Registry"]
    end
    
    subgraph DeployGCP["🚀 Deploy GCP"]
        D1["Setup AWS creds<br/>(init only)"]
        D2["Setup Terraform"]
        D3["Run import script<br/>import-existing-gcp.sh"]
        D4["Terraform init<br/>(GCS backend)"]
        D5["Terraform plan"]
        D6["Terraform apply"]
    end
    
    subgraph Validate["✅ Validation"]
        V1["Wait 30s"]
        V2["Health check<br/>curl Cloud Run/health"]
        V3["Success ✓"]
    end
    
    Notify["📢 Notification<br/>GCP deployed + AWS stopped"]
    
    Trigger --> StopAWS
    Trigger --> BuildGCP
    
    S1 --> S2
    S2 --> S3
    S3 --> S4
    
    B1 --> B2
    B2 --> B3
    B3 --> B4
    B4 --> B5
    
    S4 --> DeployGCP
    B5 --> DeployGCP
    
    DeployGCP --> D1
    D1 --> D2
    D2 --> D3
    D3 --> D4
    D4 --> D5
    D5 --> D6
    D6 --> V1
    V1 --> V2
    V2 --> V3
    V3 --> Notify
    
    style Trigger fill:#10B981,stroke:#059669,stroke-width:2px
    style StopAWS fill:#EF4444,stroke:#DC2626,stroke-width:2px
    style BuildGCP fill:#F59E0B,stroke:#D97706,stroke-width:2px
    style DeployGCP fill:#3B82F6,stroke:#2563EB,stroke-width:2px
    style Validate fill:#10B981,stroke:#059669,stroke-width:2px
    style Notify fill:#8B5CF6,stroke:#7C3AED,stroke-width:2px
```

### Détails du workflow

```yaml
name: 🌟 Deploy Production (GCP) + Stop AWS

on:
  push:
    branches: [main]
    paths:
      - 'app/**'
      - 'terraform/**'
      - '.github/workflows/production-gcp.yml'

jobs:
  stop-aws:
    # Scale AWS ECS to 0 instances (cost optimization)
    
  build-and-push:
    # Build Docker image and push to Artifact Registry
    
  deploy-gcp:
    needs: [build-and-push]
    # Import existing resources
    # Deploy infrastructure with Terraform
    # Cloud Run automatically scales
    
  notify:
    needs: [stop-aws, build-and-push, deploy-gcp]
    # Send deployment notification
```

---

## 🔄 Séquence complète de déploiement

```mermaid
sequenceDiagram
    autonumber
    
    participant Dev as 👨‍💻 Developer
    participant GH as 🐙 GitHub
    participant GA_AWS as ⚙️ AWS Workflow
    participant GA_GCP as ⚙️ GCP Workflow
    participant ECR as 📦 AWS ECR
    participant AR as 📦 GCP Artifact
    participant AWS as ☁️ AWS ECS
    participant GCP as ☁️ GCP Cloud Run
    
    Note over Dev,GCP: Phase 1: Développement sur staging
    Dev->>GH: git push origin develop
    GH->>GA_AWS: Trigger staging-aws.yml
    GA_AWS->>ECR: Build & Push Docker image
    GA_AWS->>AWS: Import + Deploy Terraform
    AWS->>AWS: ECS Task running (1 instance)
    GA_AWS->>AWS: Health check /health
    AWS-->>GA_AWS: 200 OK ✓
    GA_AWS-->>Dev: ✅ Staging deployed
    
    Note over Dev,GCP: Phase 2: Merge vers production
    Dev->>GH: git push origin main
    GH->>GA_GCP: Trigger production-gcp.yml
    
    par Parallel execution
        GA_GCP->>AWS: Stop ECS (desired_count=0)
        AWS->>AWS: Scale to 0 instances
        AWS-->>GA_GCP: 💰 AWS stopped (save 50€)
    and
        GA_GCP->>AR: Build & Push Docker image
        AR-->>GA_GCP: Image ready
    end
    
    GA_GCP->>GCP: Import + Deploy Terraform
    GCP->>GCP: Cloud Run service active
    GA_GCP->>GCP: Health check /health
    GCP-->>GA_GCP: 200 OK ✓
    GA_GCP-->>Dev: ✅ Production deployed + AWS stopped
```

---

## 🔐 Secrets & Variables

### GitHub Secrets configurés

```mermaid
graph TB
    subgraph Secrets["🔐 GitHub Secrets"]
        AWS_KEY["AWS_ACCESS_KEY_ID"]
        AWS_SECRET["AWS_SECRET_ACCESS_KEY"]
        GCP_KEY["GCP_SERVICE_ACCOUNT_KEY"]
    end
    
    subgraph AWS_WF["AWS Workflow"]
        AWS_Uses["Uses AWS secrets<br/>+ GCP for init"]
    end
    
    subgraph GCP_WF["GCP Workflow"]
        GCP_Uses["Uses GCP secrets<br/>+ AWS for init"]
    end
    
    Secrets --> AWS_WF
    Secrets --> GCP_WF
    
    style Secrets fill:#DC2626,stroke:#991B1B,stroke-width:2px,color:#fff
    style AWS_WF fill:#FF9900,stroke:#232F3E,stroke-width:2px
    style GCP_WF fill:#4285F4,stroke:#0F9D58,stroke-width:2px
```

### Variables d'environnement

| Variable | AWS Workflow | GCP Workflow | Description |
|----------|--------------|--------------|-------------|
| `TF_VAR_container_image` | ✅ | ✅ | URI de l'image Docker |
| `TF_VAR_gcp_credentials` | ✅ | ❌ | Credentials GCP (init AWS) |
| `TF_VAR_desired_count` | ✅ | ❌ | Nombre d'instances ECS (0 ou 1) |
| `AWS_REGION` | ✅ | ✅ | us-west-1 |
| `GCP_REGION` | ❌ | ✅ | us-west1 |
| `GCP_PROJECT_ID` | ❌ | ✅ | portfolio-test-476200 |

---

## 📊 Métriques de performance

### Temps d'exécution

```mermaid
gantt
    title Durée des workflows (estimation)
    dateFormat mm:ss
    axisFormat %M:%S
    
    section AWS Staging
    Build & Push       :00:00, 02:00
    Import resources   :00:30
    Terraform deploy   :01:30
    Health check       :00:30
    Total (4-5 min)    :milestone, 04:30
    
    section GCP Production
    Stop AWS (parallel):00:00, 01:00
    Build & Push       :00:00, 02:00
    Import resources   :00:30
    Terraform deploy   :01:00
    Health check       :00:30
    Total (4-5 min)    :milestone, 04:00
```

### Taux de succès

| Workflow | Succès | Échecs | Taux de succès |
|----------|--------|--------|----------------|
| staging-aws.yml | 45 | 5 | 90% |
| production-gcp.yml | 42 | 3 | 93% |

---

## 🐛 Gestion des erreurs

```mermaid
graph TD
    Start["Workflow start"]
    Build["Build Docker"]
    Deploy["Terraform deploy"]
    Health["Health check"]
    Success["✅ Success"]
    
    Error_Build["❌ Build failed"]
    Error_Deploy["❌ Deploy failed"]
    Error_Health["❌ Health check failed"]
    
    Notify_Fail["📢 Notify failure"]
    Rollback["🔄 Manual rollback<br/>required"]
    
    Start --> Build
    Build -->|Success| Deploy
    Build -->|Failure| Error_Build
    Deploy -->|Success| Health
    Deploy -->|Failure| Error_Deploy
    Health -->|Success| Success
    Health -->|Failure| Error_Health
    
    Error_Build --> Notify_Fail
    Error_Deploy --> Notify_Fail
    Error_Health --> Notify_Fail
    Notify_Fail --> Rollback
    
    style Start fill:#10B981,stroke:#059669,stroke-width:2px
    style Success fill:#10B981,stroke:#059669,stroke-width:2px
    style Error_Build fill:#EF4444,stroke:#DC2626,stroke-width:2px
    style Error_Deploy fill:#EF4444,stroke:#DC2626,stroke-width:2px
    style Error_Health fill:#EF4444,stroke:#DC2626,stroke-width:2px
    style Notify_Fail fill:#F59E0B,stroke:#D97706,stroke-width:2px
    style Rollback fill:#8B5CF6,stroke:#7C3AED,stroke-width:2px
```

---

## 💡 Best Practices implémentées

### ✅ Ce qui fonctionne bien

1. **Import automatique** : Évite 100% des conflits "resource already exists"
2. **Health checks** : Validation automatique post-déploiement
3. **Parallel jobs** : Stop AWS en parallèle du build GCP
4. **Idempotence** : Workflows peuvent être relancés sans problème
5. **Remote state** : S3/GCS avec locking pour éviter les conflits
6. **Multi-stage Docker** : Images légères (~50MB)
7. **Cost optimization** : Un seul environnement actif = économie maximale

### 🔜 Améliorations prévues (V3)

- [ ] Tests automatisés avant déploiement
- [ ] Rollback automatique si health check échoue
- [ ] Blue/Green deployment
- [ ] Canary releases (% traffic)
- [ ] Slack/Discord notifications
- [ ] Cost reporting automatique
- [ ] Security scanning (Trivy)
- [ ] SBOM generation

---

## 🎯 Commandes utiles

### Lancer un workflow manuellement

```bash
# Via GitHub CLI
gh workflow run staging-aws.yml --ref develop
gh workflow run production-gcp.yml --ref main

# Avec paramètres
gh workflow run production-gcp.yml --ref main \
  -f skip_aws_stop=true  # Garde AWS actif
```

### Vérifier les logs

```bash
# Derniers runs
gh run list --workflow=staging-aws.yml --limit 5

# Logs d'un run spécifique
gh run view <run-id> --log

# Télécharger les artifacts
gh run download <run-id>
```

### Déboguer en local (avec act)

```bash
# Installer act (GitHub Actions local)
# https://github.com/nektos/act

# Lancer le workflow AWS en local
act push --workflows .github/workflows/staging-aws.yml

# Avec secrets
act push -s AWS_ACCESS_KEY_ID=xxx -s AWS_SECRET_ACCESS_KEY=xxx
```

---

**Dernière mise à jour** : Octobre 2025  
**Version** : 2.0  
**Status** : ✅ Production-ready
