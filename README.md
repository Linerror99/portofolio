# 🚀 Portfolio DevOps & Multi-Cloud

> Infrastructure as Code avec Terraform • Déploiement multi-cloud (AWS & GCP) • CI/CD avec GitHub Actions • Containerisation Docker

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-1.6+-purple.svg)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![React](https://img.shields.io/badge/React-18.3-61DAFB.svg)](https://react.dev/)

---

## 📖 **À propos du projet**

Ce projet démontre mes compétences en **DevOps**, **Cloud Computing** et **Infrastructure as Code** en déployant un portfolio web moderne sur **AWS** et **GCP** avec une infrastructure entièrement automatisée.

### **Objectifs pédagogiques**
- ✅ Maîtriser **Terraform** pour l'infrastructure multi-cloud
- ✅ Créer des **modules réutilisables** provider-agnostiques
- ✅ Implémenter un **CI/CD robuste** avec GitHub Actions
- ✅ Utiliser **OIDC** pour l'authentification sécurisée (zero secrets)
- ✅ Containeriser avec **Docker** (build multi-stage)
- ✅ Gérer le **state Terraform** distant (S3, GCS)

---

## 🏗️ **Architecture**

```
┌─────────────────────────────────────────────────────────┐
│                    GitHub Repository                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   React App  │  │  Terraform   │  │   CI/CD      │  │
│  │   (Vite)     │  │   Modules    │  │   Workflows  │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                            │
                ┌───────────┴───────────┐
                │                       │
        ┌───────▼──────┐        ┌──────▼───────┐
        │     AWS      │        │     GCP      │
        │              │        │              │
        │  • ECR       │        │  • Artifact  │
        │  • ECS       │        │    Registry  │
        │  • Fargate   │        │  • Cloud Run │
        │  • ALB       │        │  • VPC       │
        └──────────────┘        └──────────────┘
```

---

## 📁 **Structure du projet**

```
portofolio/
├── app/                          # Application React+Vite
│   ├── src/
│   │   ├── components/          # Composants réutilisables
│   │   ├── pages/               # Pages (Home, About, Portfolio, Contact)
│   │   └── styles/              # Styles Tailwind CSS
│   ├── Dockerfile               # Build multi-stage
│   ├── nginx.conf               # Configuration Nginx
│   └── package.json
│
├── terraform/                    # Infrastructure as Code
│   ├── modules/                 # Modules réutilisables
│   │   ├── container-registry/  # ECR + Artifact Registry
│   │   ├── compute/             # ECS Fargate + Cloud Run
│   │   └── backend/             # State management
│   └── environments/            # Configs par cloud
│       ├── aws/
│       └── gcp/
│
├── .github/                      # CI/CD
│   └── workflows/
│       ├── docker-build-push.yml
│       ├── terraform-aws.yml
│       └── terraform-gcp.yml
│
├── scripts/                      # Scripts d'automation
│   ├── init-backend-aws.sh
│   ├── init-backend-gcp.sh
│   └── deploy-local.sh
│
└── docs/                         # Documentation
    ├── architecture.md
    ├── setup-aws.md
    └── setup-gcp.md
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
docker run -p 8080:80 portfolio:local

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

### ✅ **Phase 0 : Setup Initial** (En cours)
- [x] Structure de dossiers
- [x] Application React+Vite fonctionnelle
- [x] Dockerfile multi-stage
- [x] Configuration de base
- [ ] Tests locaux

### 🔜 **Phase 1 : Modules Terraform**
- [ ] Module Container Registry
- [ ] Module Compute
- [ ] Module Backend State

### 🔜 **Phase 2 : Environments AWS & GCP**
- [ ] Configuration AWS
- [ ] Configuration GCP
- [ ] Backends distants

### 🔜 **Phase 3 : CI/CD**
- [ ] Workflow Docker build/push
- [ ] Workflow Terraform plan/apply
- [ ] Configuration OIDC

### 🔜 **Phase 4 : Scripts & Automation**
- [ ] Scripts d'initialisation
- [ ] Scripts de validation
- [ ] Scripts de déploiement

### 🔜 **Phase 5 : Tests & Validation**
- [ ] Tests end-to-end
- [ ] Déploiement sur AWS
- [ ] Déploiement sur GCP

### 🔜 **Phase 6 : Documentation**
- [ ] Documentation technique
- [ ] Guides de setup
- [ ] Diagrammes d'architecture

---

## 🧪 **Tests**

### **Tests locaux**

```bash
# App en dev
cd app && npm run dev

# Build Docker
docker build -t portfolio:test ./app
docker run -p 8080:80 portfolio:test

# Healthcheck
curl http://localhost:8080/health
```

### **Validation Terraform** (à venir)

```bash
cd terraform/environments/aws
terraform init
terraform validate
terraform plan
```

---

## 📝 **Branches Git**

- `main` - Code stable, déploiement automatique
- `develop` - Intégration continue
- `feature/*` - Features individuelles
- `infra/aws` - Infrastructure AWS
- `infra/gcp` - Infrastructure GCP

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

**Votre Nom**  
🔗 [GitHub](https://github.com/Linerror99) • [LinkedIn](#) • [Portfolio](#)

---

## 🙏 **Remerciements**

- Inspiré par [EkiZR Portfolio V5](https://github.com/EkiZR/Portofolio_V5)
- Merci à la communauté DevOps et Cloud
- Documentation officielle AWS, GCP, Terraform

---

**⭐ Si ce projet vous aide, n'hésitez pas à lui donner une étoile !**
