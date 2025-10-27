# 🚀 Portfolio DevOps & Multi-Cloud - V2

> Infrastructure as Code avec Terraform • CI/CD Multi-Cloud Intelligent • AWS + GCP • Économie automatique de ressources

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-1.6+-purple.svg)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![React](https://img.shields.io/badge/React-18.3-61DAFB.svg)](https://react.dev/)
[![AWS](https://img.shields.io/badge/AWS-ECS%20Fargate-FF9900.svg)](https://aws.amazon.com/)
[![GCP](https://img.shields.io/badge/GCP-Cloud%20Run-4285F4.svg)](https://cloud.google.com/)

---

## 📖 **À propos du projet**

Portfolio personnel moderne avec une infrastructure DevOps multi-cloud **intelligente et économique**. Ce projet démontre l'utilisation avancée de Terraform, Docker et GitHub Actions pour un déploiement automatisé sur AWS et GCP avec **gestion automatique des ressources** pour minimiser les coûts.

### **🎯 Fonctionnalités principales**
- 🚀 **CI/CD Intelligent** : Déploiement automatique selon la branche
  - `develop` → AWS ECS Fargate (Staging)
  - `main` → GCP Cloud Run (Production) + Arrêt automatique AWS
- 💰 **Économie de ressources** : ~45-50€/mois économisés grâce au système d'arrêt automatique
- 🔄 **Import automatique** : Évite les erreurs "resource already exists"
- 🏗️ **Modules Terraform réutilisables** : Provider-agnostiques (AWS/GCP)
- 🐳 **Docker optimisé** : Build multi-stage avec Nginx
- 📊 **Backend state distant** : S3 pour AWS, GCS pour GCP

### **💡 Innovation technique**
Le système de CI/CD détecte automatiquement la branche et :
- ✅ Active l'environnement correspondant (AWS staging OU GCP production)
- ✅ Arrête l'environnement précédent (économie de ressources)
- ✅ Importe les ressources existantes (zéro conflit Terraform)
- ✅ Déploie et valide via health checks

---

## 🏗️ **Architecture Multi-Cloud Intelligente**

```
┌─────────────────────────────────────────────────────────────────┐
│                        GitHub Repository                         │
│  ┌─────────┐  ┌──────────────┐  ┌─────────────────────────┐   │
│  │ React   │  │  Terraform   │  │    GitHub Actions       │   │
│  │ App     │  │  Modules     │  │  ├─ staging-aws.yml     │   │
│  │ (Vite)  │  │  (Reusable)  │  │  └─ production-gcp.yml  │   │
│  └─────────┘  └──────────────┘  └─────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┴────────────────────┐
        │                                        │
        │ develop branch                         │ main branch
        ▼                                        ▼
┌──────────────────────┐              ┌──────────────────────┐
│   AWS (Staging)      │              │   GCP (Production)   │
│   💰 ~65€/mois       │              │   💰 ~15€/mois       │
├──────────────────────┤              ├──────────────────────┤
│ • ECR (registry)     │              │ • Artifact Registry  │
│ • ECS Fargate        │              │ • Cloud Run          │
│ • ALB (load balancer)│              │ • VPC Connector      │
│ • VPC (networking)   │              │ • IAM (security)     │
│ • Route 53 (DNS)     │              │ • Cloud Logging      │
│ • CloudWatch (logs)  │              │                      │
│                      │              │                      │
│ State: S3 + DynamoDB │              │ State: GCS bucket    │
└──────────────────────┘              └──────────────────────┘
        ▲                                        │
        │                                        │
        └────────────────┬───────────────────────┘
                         │
                    Auto-stop AWS
                 (économie ~45-50€/mois)
```

### **🔄 Flux de déploiement**
1. **Push sur `develop`** → Deploy AWS staging (ECS actif)
2. **Push sur `main`** → Stop AWS + Deploy GCP production (Cloud Run actif)
3. **Résultat** : Un seul environnement actif à la fois = **économie maximale**

---

## 📁 **Structure du projet**

```
portofolio/
├── app/                                    # Application React+Vite
│   ├── src/
│   │   ├── components/                    # Composants réutilisables
│   │   ├── pages/                         # Pages (Home, About, Portfolio, Contact)
│   │   └── styles/                        # Styles Tailwind CSS
│   ├── Dockerfile                         # Build multi-stage (Node + Nginx)
│   ├── nginx.conf                         # Configuration Nginx optimisée
│   └── package.json
│
├── terraform/                              # Infrastructure as Code
│   ├── modules/                           # Modules réutilisables (provider-agnostic)
│   │   ├── backend/                       # State management (S3/GCS)
│   │   ├── container-registry/            # ECR + Artifact Registry
│   │   └── compute/                       # ECS Fargate + Cloud Run
│   │       ├── main.tf                    # Logique principale
│   │       ├── variables.tf               # Variables avec validation
│   │       ├── outputs.tf                 # Outputs essentiels
│   │       ├── aws-ecs.tf                # Ressources AWS spécifiques
│   │       └── gcp-cloudrun.tf           # Ressources GCP spécifiques
│   │
│   ├── environments/                      # Configurations par environnement
│   │   ├── aws-complete/                 # AWS Staging (develop)
│   │   │   ├── main.tf                   # Config AWS + modules
│   │   │   ├── backend.tf                # S3 + DynamoDB state
│   │   │   ├── variables.tf              # Variables AWS (desired_count, etc.)
│   │   │   └── terraform.tfvars          # Valeurs concrètes
│   │   │
│   │   └── gcp-complete/                 # GCP Production (main)
│   │       ├── main.tf                   # Config GCP + modules
│   │       ├── backend.tf                # GCS state
│   │       ├── variables.tf              # Variables GCP
│   │       └── terraform.tfvars          # Valeurs concrètes
│   │
│   └── scripts/                          # Scripts d'automatisation
│       ├── import-existing-aws.sh        # Import ressources AWS existantes
│       └── import-existing-gcp.sh        # Import ressources GCP existantes
│
├── .github/                               # CI/CD GitHub Actions
│   └── workflows/
│       ├── staging-aws.yml               # Deploy AWS staging (develop)
│       └── production-gcp.yml            # Deploy GCP prod + stop AWS (main)
│
├── scripts/                               # Scripts utilitaires
│   ├── import-existing-aws.sh            # (copie pour exécution locale)
│   └── import-existing-gcp.sh            # (copie pour exécution locale)
│
└── docs/                                  # Documentation (à venir)
    ├── ARCHITECTURE.md
    ├── CICD_PIPELINE.md
    └── COST_OPTIMIZATION.md
```

---

## 🚀 **Quick Start**

### **Prérequis**

- [Node.js](https://nodejs.org/) 20+ et npm
- [Docker](https://www.docker.com/) 24+
- [Terraform](https://www.terraform.io/) 1.6+
- Comptes [AWS](https://aws.amazon.com/) et [GCP](https://cloud.google.com/)

### **1. Lancer l'application en local (dev)**

```bash
cd app
npm install
npm run dev
```

➡️ Ouvrir [http://localhost:5173](http://localhost:5173)

### **2. Build de production**

```bash
npm run build
npm run preview  # Prévisualiser le build
```

### **3. Tester avec Docker**

```bash
# Build l'image
docker build -t portfolio:local ./app

# Lancer le container
docker run -p 8080:8080 portfolio:local

# Tester
curl http://localhost:8080/health
```

➡️ Ouvrir [http://localhost:8080](http://localhost:8080)

---

## 🛠️ **Stack Technique**

### **Frontend**
- **React 18** - Framework UI moderne
- **Vite 5** - Build tool ultra-rapide
- **Tailwind CSS 3** - Styling utility-first
- **Framer Motion** - Animations fluides
- **React Router** - Navigation SPA

### **Infrastructure**
- **Terraform** - Infrastructure as Code
- **Docker** - Containerisation
- **Nginx** - Serveur web production
- **AWS** - ECS Fargate, ECR, ALB
- **GCP** - Cloud Run, Artifact Registry

### **CI/CD**
- **GitHub Actions** - Automation
- **OIDC** - Authentication sécurisée
- **Trivy** - Scan de sécurité (à venir)

---

## 📦 **Phases de développement**

### ✅ **Phase 0 : Setup Initial** (Terminé)
- [x] Structure de dossiers
- [x] Application React+Vite fonctionnelle
- [x] Dockerfile multi-stage (port 8080)
- [x] Configuration de base
- [x] Tests locaux

### ✅ **Phase 1 : Modules Terraform** (Terminé)
- [x] Module Backend State (S3+DynamoDB, GCS)
- [x] Module Container Registry (ECR, Artifact Registry)
- [x] Module Compute (ECS Fargate, Cloud Run)
- [x] Architecture multi-cloud provider-agnostique

### ✅ **Phase 2 : Environment AWS Complete** (Terminé)
- [x] Backend State AWS déployé
- [x] ECR Repository créé
- [x] ECS Fargate + ALB en production
- [x] VPC avec subnets publics/privés
- [x] Security Groups configurés
- [x] Portfolio accessible : `http://portfolio-prod-alb-858439454.us-west-1.elb.amazonaws.com`

### � **Phase 3 : HTTPS & Domaine Personnalisé** (En cours)
- [x] Module Route 53 pour gestion DNS
- [x] Configuration certificat SSL (ACM)
- [x] Variables pour domaine personnalisé
- [ ] 🎯 **Achat du domaine** (prochaine étape)
- [ ] Configuration nameservers
- [ ] Tests HTTPS complets

### 🔜 **Phase 4 : Environment GCP**
- [ ] Configuration GCP avec modules existants
- [ ] Déploiement Cloud Run
- [ ] Tests multi-cloud

### 🔜 **Phase 5 : CI/CD**
- [ ] Workflow Docker build/push
- [ ] Workflow Terraform plan/apply
- [ ] Configuration OIDC

### 🔜 **Phase 6 : Documentation & Finalisation**
- [x] Guide HTTPS & domaine personnalisé
- [ ] Documentation complète des modules
- [ ] Diagrammes d'architecture actualisés

---

## 🌐 **URLs de déploiement**

### **🔴 AWS Staging (develop branch)**
- **ALB URL** : `http://portfolio-prod-alb-858439454.us-west-1.elb.amazonaws.com`
- **État** : Actif quand develop reçoit des commits
- **Coût** : ~65€/mois (automatiquement arrêté lors du merge vers main)

### **🟢 GCP Production (main branch)**
- **Cloud Run URL** : Accessible après déploiement
- **État** : Actif en production
- **Coût** : ~15€/mois

### **🔒 Domaine personnalisé (V4 - À venir)**
- **Domaine** : `ldjossou.com` (en attente de propagation DNS)
- **HTTPS** : Certificats SSL automatiques (ACM + GCP managed)
- **CDN** : CloudFront / Cloud CDN pour performance globale

---

## 💰 **Optimisation des coûts**

### **💡 Système intelligent d'économie**

L'infrastructure utilise un système de **gestion automatique des ressources** :

| Événement | AWS Staging | GCP Production | Économie |
|-----------|-------------|----------------|----------|
| **Push sur `develop`** | ✅ Actif (1 instance) | ⚫ Inactif | - |
| **Push sur `main`** | 🛑 Arrêté (0 instance) | ✅ Actif | ~45-50€/mois |

### **📊 Détails des coûts**

**AWS ECS Fargate (Staging)** :
- ECS Task : 0.5 vCPU, 1GB RAM
- ALB : Load balancer
- VPC : NAT Gateway, Elastic IP
- **Total** : ~65€/mois

**GCP Cloud Run (Production)** :
- CPU : 1 vCPU, 1GB RAM
- Scale to zero : Facturation à l'usage
- Networking : Minimal
- **Total** : ~15€/mois

**Économie réalisée** : ~45-50€/mois grâce au système d'arrêt automatique ! �

---

## 🧪 **Tests**

### **Tests locaux**

```bash
# App en dev
cd app && npm run dev

# Build Docker
docker build -t portfolio:test ./app
docker run -p 8080:8080 portfolio:test

# Healthcheck
curl http://localhost:8080/health
```

### **Tests de l'infrastructure AWS déployée**

```bash
# Infrastructure en production
curl -I http://portfolio-prod-alb-858439454.us-west-1.elb.amazonaws.com

# Health check
curl http://portfolio-prod-alb-858439454.us-west-1.elb.amazonaws.com/health

# Après configuration domaine (exemple avec ldjossou.com)
curl -I https://ldjossou.com
```

### **Validation Terraform**

```bash
# Environment AWS Complete
cd terraform/environments/aws-complete
terraform init
terraform validate
terraform plan
terraform apply

# Voir les outputs
terraform output
terraform output load_balancer_url

# Avec domaine personnalisé (exemple)
# 1. Ajouter dans terraform.tfvars :
# domain_name = "ldjossou.com"
# create_route53_zone = true  
# enable_https = true

# 2. Appliquer
terraform apply

# 3. Configurer nameservers chez registraire
terraform output route53_name_servers
```

---

## 🤝 **Contribution**

Ce projet est à vocation pédagogique. Les suggestions sont bienvenues !

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

---

## 📄 **Licence**

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## 👨‍💻 **Auteur**

**Luc Djossou**  
DevOps Engineer | Cloud Architecture | Infrastructure as Code

🔗 [GitHub](https://github.com/Linerror99) • [LinkedIn](https://linkedin.com/in/ldjossou) • [Portfolio](https://ldjossou.com)

---

## 🙏 **Remerciements**

- Inspiré par [EkiZR Portfolio V5](https://github.com/EkiZR/Portofolio_V5)
- Merci à la communauté DevOps et Cloud
- Documentation officielle AWS, GCP, Terraform

---

**⭐ Si ce projet vous aide, n'hésitez pas à lui donner une étoile !**
