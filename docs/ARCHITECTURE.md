# 🏗️ Architecture Multi-Cloud

## Vue d'ensemble de l'infrastructure

```mermaid
graph TB
    subgraph GitHub["🐙 GitHub Repository"]
        App["📱 React App<br/>(Vite + Tailwind)"]
        TF["🔧 Terraform<br/>Modules"]
        CI["⚙️ GitHub Actions<br/>Workflows"]
    end

    subgraph AWS["☁️ AWS Staging (develop)"]
        direction TB
        AWS_Cost["💰 ~65€/mois"]
        ECR["📦 ECR<br/>Container Registry"]
        ECS["🚀 ECS Fargate<br/>Containerized App"]
        ALB["⚖️ Application<br/>Load Balancer"]
        VPC_AWS["🌐 VPC<br/>Networking"]
        R53["🌍 Route 53<br/>DNS"]
        CW["📊 CloudWatch<br/>Logs"]
        S3["💾 S3 + DynamoDB<br/>Terraform State"]
    end

    subgraph GCP["☁️ GCP Production (main)"]
        direction TB
        GCP_Cost["💰 ~15€/mois"]
        AR["📦 Artifact Registry<br/>Container Registry"]
        CR["🚀 Cloud Run<br/>Serverless"]
        VPC_GCP["🌐 VPC Connector<br/>Networking"]
        IAM["🔐 IAM<br/>Security"]
        CL["📊 Cloud Logging<br/>Monitoring"]
        GCS["💾 GCS Bucket<br/>Terraform State"]
    end

    subgraph AutoStop["💡 Smart Resource Management"]
        Stop["🛑 Auto-Stop AWS<br/>when GCP active"]
        Save["💰 Saves ~45-50€/month"]
    end

    GitHub -->|"Push to develop"| AWS
    GitHub -->|"Push to main"| GCP
    GCP -.->|"Triggers"| AutoStop
    AutoStop -.->|"Scales to 0"| AWS

    style AWS fill:#FF9900,stroke:#232F3E,stroke-width:3px,color:#000
    style GCP fill:#4285F4,stroke:#0F9D58,stroke-width:3px,color:#fff
    style GitHub fill:#24292e,stroke:#fff,stroke-width:2px,color:#fff
    style AutoStop fill:#10B981,stroke:#059669,stroke-width:2px,color:#fff
```

## 🎯 Flux de déploiement intelligent

```mermaid
sequenceDiagram
    participant Dev as 👨‍💻 Développeur
    participant GitHub as 🐙 GitHub
    participant AWS as ☁️ AWS Staging
    participant GCP as ☁️ GCP Production

    Note over Dev,GCP: Scénario 1: Développement (develop branch)
    Dev->>GitHub: git push origin develop
    GitHub->>AWS: Deploy via staging-aws.yml
    AWS->>AWS: ECS active (1 instance)
    Note over AWS: 💰 Coût: ~65€/mois
    AWS-->>Dev: ✅ Staging deployed

    Note over Dev,GCP: Scénario 2: Production (main branch)
    Dev->>GitHub: git push origin main
    GitHub->>AWS: Stop ECS (desired_count=0)
    AWS->>AWS: Scale down to 0
    Note over AWS: 💰 Économie: ~50€/mois
    GitHub->>GCP: Deploy via production-gcp.yml
    GCP->>GCP: Cloud Run active
    Note over GCP: 💰 Coût: ~15€/mois
    GCP-->>Dev: ✅ Production deployed + AWS stopped
```

## 🔄 Architecture des modules Terraform

```mermaid
graph LR
    subgraph Modules["📦 Terraform Modules (Réutilisables)"]
        Backend["🗄️ Backend<br/>S3 / GCS"]
        Registry["📦 Registry<br/>ECR / Artifact"]
        Compute["🚀 Compute<br/>ECS / Cloud Run"]
    end

    subgraph AWS_Env["🟠 AWS Environment"]
        AWS_Main["main.tf"]
        AWS_Vars["variables.tf"]
        AWS_Backend["backend.tf<br/>(S3)"]
    end

    subgraph GCP_Env["🔵 GCP Environment"]
        GCP_Main["main.tf"]
        GCP_Vars["variables.tf"]
        GCP_Backend["backend.tf<br/>(GCS)"]
    end

    AWS_Main --> Backend
    AWS_Main --> Registry
    AWS_Main --> Compute
    
    GCP_Main --> Backend
    GCP_Main --> Registry
    GCP_Main --> Compute

    style Modules fill:#7C3AED,stroke:#5B21B6,stroke-width:2px,color:#fff
    style AWS_Env fill:#FF9900,stroke:#232F3E,stroke-width:2px,color:#000
    style GCP_Env fill:#4285F4,stroke:#0F9D58,stroke-width:2px,color:#fff
```

## 🌐 Architecture réseau détaillée

### AWS ECS Fargate

```mermaid
graph TB
    Internet["🌍 Internet"]
    
    subgraph VPC["VPC (10.0.0.0/16)"]
        subgraph Public["Public Subnets"]
            ALB["Application<br/>Load Balancer"]
            NAT["NAT Gateway"]
        end
        
        subgraph Private["Private Subnets"]
            ECS1["ECS Task 1<br/>10.0.1.x"]
            ECS2["ECS Task 2<br/>10.0.2.x"]
        end
        
        subgraph Security["Security Groups"]
            SG_ALB["SG ALB<br/>80, 443"]
            SG_ECS["SG ECS<br/>8080"]
        end
    end
    
    ECR["ECR<br/>Docker Images"]
    CW["CloudWatch<br/>Logs"]
    
    Internet --> ALB
    ALB --> ECS1
    ALB --> ECS2
    ECS1 --> NAT
    ECS2 --> NAT
    NAT --> Internet
    ECR -.->|"Pull images"| ECS1
    ECR -.->|"Pull images"| ECS2
    ECS1 -.->|"Logs"| CW
    ECS2 -.->|"Logs"| CW
    
    style Internet fill:#E5E7EB,stroke:#6B7280,stroke-width:2px
    style VPC fill:#FEF3C7,stroke:#F59E0B,stroke-width:3px
    style Public fill:#DBEAFE,stroke:#3B82F6,stroke-width:2px
    style Private fill:#FEE2E2,stroke:#EF4444,stroke-width:2px
```

### GCP Cloud Run

```mermaid
graph TB
    Internet["🌍 Internet"]
    
    subgraph GCP["GCP Project"]
        subgraph CloudRun["Cloud Run Service"]
            CR1["Container Instance 1"]
            CR2["Container Instance 2"]
            CR3["Container Instance N<br/>(Auto-scaled)"]
        end
        
        AR["Artifact Registry<br/>Docker Images"]
        VPC["VPC Connector"]
        CL["Cloud Logging"]
        IAM["IAM<br/>Public Access"]
    end
    
    Internet --> CloudRun
    CloudRun --> VPC
    AR -.->|"Pull images"| CR1
    AR -.->|"Pull images"| CR2
    AR -.->|"Pull images"| CR3
    CR1 -.->|"Logs"| CL
    CR2 -.->|"Logs"| CL
    CR3 -.->|"Logs"| CL
    IAM -.->|"Allow unauthenticated"| CloudRun
    
    style Internet fill:#E5E7EB,stroke:#6B7280,stroke-width:2px
    style GCP fill:#E0F2FE,stroke:#0EA5E9,stroke-width:3px
    style CloudRun fill:#DBEAFE,stroke:#3B82F6,stroke-width:2px
```

## 📊 Comparaison des services

| Composant | AWS | GCP |
|-----------|-----|-----|
| **Container Registry** | ECR | Artifact Registry |
| **Compute** | ECS Fargate | Cloud Run |
| **Load Balancer** | Application LB | Built-in (serverless) |
| **Networking** | VPC + Subnets | VPC Connector |
| **DNS** | Route 53 | Cloud DNS |
| **Logs** | CloudWatch | Cloud Logging |
| **State Backend** | S3 + DynamoDB | GCS |
| **Cost (monthly)** | ~65€ | ~15€ |
| **Scaling** | ECS Service (min/max) | Auto (0 to N) |
| **Startup** | ~30-60s | ~5-10s |

## 💡 Décisions d'architecture

### Pourquoi deux clouds ?

1. **Compétences multi-cloud** : Démonstration de maîtrise AWS + GCP
2. **Optimisation coûts** : GCP Cloud Run moins cher pour production (~70% d'économie)
3. **Résilience** : Capacité de basculer entre clouds si besoin
4. **Apprentissage** : Expérience concrète des deux écosystèmes

### Pourquoi ce split develop/main ?

1. **Économie** : Un seul environnement actif = ~45-50€/mois économisés
2. **Réaliste** : Simule un vrai workflow staging → production
3. **Automatisation** : Déploiement et arrêt entièrement automatisés
4. **Flexibilité** : Facile de tester les deux environnements

### Choix techniques

| Décision | Justification |
|----------|---------------|
| **Terraform modules réutilisables** | Code DRY, facile à maintenir |
| **Remote state backend** | Collaboration, lock, versioning |
| **Docker multi-stage** | Images légères (~50MB vs ~1GB) |
| **Nginx** | Performance, configuration flexible |
| **Import scripts** | Évite conflits "already exists" |
| **Health checks** | Validation automatique post-déploiement |

## 🔐 Sécurité

```mermaid
graph TD
    subgraph Security["🔐 Layers de sécurité"]
        L1["1. GitHub Secrets<br/>(Credentials chiffrés)"]
        L2["2. IAM Roles<br/>(Least privilege)"]
        L3["3. Security Groups<br/>(Firewall rules)"]
        L4["4. HTTPS/TLS<br/>(Traffic encryption)"]
        L5["5. VPC Isolation<br/>(Network segmentation)"]
    end
    
    L1 --> L2
    L2 --> L3
    L3 --> L4
    L4 --> L5
    
    style Security fill:#DC2626,stroke:#991B1B,stroke-width:2px,color:#fff
```

---

**Dernière mise à jour** : Octobre 2025  
**Version** : 1.0
