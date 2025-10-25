# 🐳 Container Registry Module

## 📋 Description

Ce module Terraform crée un **container registry privé** pour stocker vos images Docker de manière sécurisée.

### Qu'est-ce qu'un Container Registry ?

Un **container registry** est un endroit où tu stockes tes images Docker. C'est comme un **Docker Hub privé**.

**Pourquoi en avoir besoin ?**
- ✅ **Sécurité** : Images privées (pas publiques comme Docker Hub)
- ✅ **Performance** : Images dans la même région que tes apps (latence faible)
- ✅ **Scan de vulnérabilités** : Détection automatique des failles de sécurité
- ✅ **Gestion des versions** : Garde plusieurs versions de tes images
- ✅ **Intégration native** : ECS/Cloud Run peuvent directement pull les images

---

## 🏗️ Architecture

### AWS (ECR)
```
┌─────────────────────────────────────────┐
│   Elastic Container Registry (ECR)      │
│  portfolio-prod-app                     │
│  ┌───────────────────────────────────┐  │
│  │  Images Docker                    │  │
│  │  - portfolio:1.0.0                │  │
│  │  - portfolio:1.0.1                │  │
│  │  - portfolio:latest               │  │
│  │                                   │  │
│  │  Features:                        │  │
│  │  ✅ Scan automatique              │  │
│  │  ✅ Chiffrement AES-256           │  │
│  │  ✅ Lifecycle policy (garde 10)   │  │
│  │  ✅ Tag mutability                │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

### GCP (Artifact Registry)
```
┌─────────────────────────────────────────┐
│   Artifact Registry                     │
│  portfolio-prod-app                     │
│  ┌───────────────────────────────────┐  │
│  │  Images Docker                    │  │
│  │  - portfolio:1.0.0                │  │
│  │  - portfolio:1.0.1                │  │
│  │  - portfolio:latest               │  │
│  │                                   │  │
│  │  Features:                        │  │
│  │  ✅ Cleanup policies              │  │
│  │  ✅ Chiffrement par défaut        │  │
│  │  ✅ Garde 10 versions             │  │
│  │  ✅ Supprime untagged après 7j    │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

---

## 📦 Ressources Créées

### AWS (si `cloud_provider = "aws"`)
1. **ECR Repository** : Stockage des images Docker
2. **Lifecycle Policy** : Gestion automatique de la rétention
3. **Image Scanning** : Scan automatique des vulnérabilités
4. **Encryption** : Chiffrement AES-256 au repos

### GCP (si `cloud_provider = "gcp"`)
1. **Artifact Registry Repository** : Stockage des images Docker
2. **Cleanup Policies** : Suppression automatique des images anciennes/untagged
3. **Encryption** : Chiffrement par défaut de GCP

---

## 🚀 Utilisation

### Exemple AWS

```hcl
module "container_registry" {
  source = "./modules/container-registry"

  cloud_provider         = "aws"
  project_name           = "portfolio"
  environment            = "prod"
  repository_name        = "app"
  region                 = "us-west-1"
  
  # Configuration
  scan_on_push              = true
  image_tag_mutability      = "MUTABLE"
  enable_lifecycle_policy   = true
  image_retention_count     = 10

  tags = {
    Project = "Portfolio"
  }
}
```

### Exemple GCP

```hcl
module "container_registry" {
  source = "./modules/container-registry"

  cloud_provider         = "gcp"
  project_name           = "portfolio"
  environment            = "prod"
  repository_name        = "app"
  gcp_project_id         = "portfolio-test-476200"
  gcp_region             = "us-west1"
  
  # Configuration
  scan_on_push              = true
  enable_lifecycle_policy   = true
  image_retention_count     = 10

  tags = {
    project = "portfolio"
  }
}
```

---

## 📤 Outputs

| Output | Description | AWS | GCP |
|--------|-------------|-----|-----|
| `registry_url` | URL complète du registry | ✅ | ✅ |
| `repository_name` | Nom du repository | ✅ | ✅ |
| `repository_arn` | ARN du repository ECR | ✅ | ❌ |
| `repository_id` | ID du repository Artifact | ❌ | ✅ |
| `region` | Région du registry | ✅ | ✅ |
| `docker_commands` | Commandes Docker prêtes | ✅ | ✅ |

---

## 🐳 Utiliser le Registry

### AWS - Workflow complet

```bash
# 1. Se connecter au registry ECR
aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-west-1.amazonaws.com

# 2. Builder l'image
docker build -t portfolio-app .

# 3. Tagger l'image
docker tag portfolio-app:latest 123456789012.dkr.ecr.us-west-1.amazonaws.com/portfolio-prod-app:latest

# 4. Pousser l'image
docker push 123456789012.dkr.ecr.us-west-1.amazonaws.com/portfolio-prod-app:latest

# 5. Pull l'image
docker pull 123456789012.dkr.ecr.us-west-1.amazonaws.com/portfolio-prod-app:latest
```

### GCP - Workflow complet

```bash
# 1. Configurer Docker pour Artifact Registry
gcloud auth configure-docker us-west1-docker.pkg.dev

# 2. Builder l'image
docker build -t portfolio-app .

# 3. Tagger l'image
docker tag portfolio-app:latest us-west1-docker.pkg.dev/portfolio-test-476200/portfolio-prod-app/app:latest

# 4. Pousser l'image
docker push us-west1-docker.pkg.dev/portfolio-test-476200/portfolio-prod-app/app:latest

# 5. Pull l'image
docker pull us-west1-docker.pkg.dev/portfolio-test-476200/portfolio-prod-app/app:latest
```

---

## 📋 Variables d'Entrée

| Variable | Type | Requis | Défaut | Description |
|----------|------|--------|--------|-------------|
| `cloud_provider` | string | ✅ | - | Provider (`aws` ou `gcp`) |
| `project_name` | string | ✅ | - | Nom du projet |
| `environment` | string | ❌ | `prod` | Environnement |
| `repository_name` | string | ❌ | `app` | Nom du repository |
| `region` | string | ❌ | `us-west-1` | Région AWS |
| `gcp_project_id` | string | ⚠️* | - | ID projet GCP (*requis si GCP) |
| `gcp_region` | string | ❌ | `us-west1` | Région GCP |
| `image_tag_mutability` | string | ❌ | `MUTABLE` | Mutabilité des tags (AWS) |
| `scan_on_push` | bool | ❌ | `true` | Scan auto des images |
| `enable_lifecycle_policy` | bool | ❌ | `true` | Politique de rétention |
| `image_retention_count` | number | ❌ | `10` | Nb d'images à garder |
| `tags` | map(string) | ❌ | `{}` | Tags/Labels |

---

## 🔒 Sécurité

### AWS
- ✅ **Images privées** : Pas d'accès public
- ✅ **Scan de vulnérabilités** : Détection automatique des CVE
- ✅ **Chiffrement** : AES-256 au repos
- ✅ **IAM** : Contrôle d'accès granulaire

### GCP
- ✅ **Images privées** : Pas d'accès public
- ✅ **Chiffrement** : Par défaut de GCP
- ✅ **IAM** : Contrôle d'accès via roles GCP
- ✅ **Binary Authorization** : (optionnel) Signature des images

---

## 🧪 Tests

### 1. Valider la configuration
```bash
cd terraform/modules/container-registry
terraform init
terraform validate
```

### 2. Tester avec AWS
```bash
cd terraform/environments/aws
terraform plan
terraform apply
```

### 3. Tester avec GCP
```bash
cd terraform/environments/gcp
terraform plan
terraform apply
```

### 4. Pousser une image de test
```bash
# Récupérer l'URL du registry
terraform output registry_url

# Utiliser les commandes Docker de l'output
terraform output docker_commands
```

---

## 💡 Concepts Clés

### Image Tag Mutability (AWS uniquement)

**MUTABLE** (par défaut) :
- Tu peux écraser un tag existant
- `docker push myapp:1.0` → écrase l'ancienne version

**IMMUTABLE** :
- Un tag ne peut être poussé qu'une seule fois
- `docker push myapp:1.0` → erreur si déjà existant
- ✅ Recommandé pour la production (traçabilité)

### Lifecycle Policy / Cleanup Policy

**Problème** : Les images s'accumulent → coûts de stockage

**Solution** : Politique de rétention automatique
- Garde les **N images les plus récentes** (ex: 10)
- Supprime les **images untagged** après X jours (ex: 7)
- Libère de l'espace automatiquement

### Scan de Vulnérabilités

Détecte les **CVE (Common Vulnerabilities and Exposures)** dans tes images :
- ✅ Bibliothèques obsolètes
- ✅ Packages avec failles de sécurité
- ✅ Rapports de scan dans la console

**Best practice** : Toujours activer `scan_on_push = true`

---

## 🆘 Troubleshooting

### Erreur : Repository already exists
```
Error: RepositoryAlreadyExistsException
```

**Solution** : Le repository existe déjà. Change `repository_name` ou supprime l'ancien.

### Erreur : Authentication required
```
Error: no basic auth credentials
```

**Solution AWS** :
```bash
aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin <registry_url>
```

**Solution GCP** :
```bash
gcloud auth configure-docker us-west1-docker.pkg.dev
```

### Erreur : Permission denied
```
Error: AccessDeniedException
```

**Solution** : Vérifie tes permissions IAM/GCP pour créer des registries.

---

## 📚 Ressources

- [AWS ECR Documentation](https://docs.aws.amazon.com/ecr/)
- [GCP Artifact Registry Documentation](https://cloud.google.com/artifact-registry/docs)
- [Docker Registry Best Practices](https://docs.docker.com/registry/deploying/)

---

**Auteur** : Portfolio Project  
**Version** : 1.0.0  
**Dernière mise à jour** : 2025
