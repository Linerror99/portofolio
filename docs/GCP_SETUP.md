# 🌐 Setup GCP Environment 

## 🎯 **Plan actuel :**
1. ✅ **AWS + domaine** : En cours (propagation DNS)
2. 🚀 **GCP sans domaine** : Maintenant !
3. 🎯 **GCP + domaine** : Après validation AWS

## 🔧 **Prérequis GCP**

### 1. **Créer un projet GCP** (si pas encore fait)
```bash
# Via Console GCP : https://console.cloud.google.com/
# Nouveau projet → Nom: "portfolio-gcp" → Créer
# Noter le Project ID : ex: "portfolio-gcp-123456"
```

### 2. **Activer les APIs requises**
```bash
# Cloud Run API
# Artifact Registry API  
# Cloud Build API (optionnel)
```

### 3. **Authentication**
```bash
# Installer gcloud CLI si pas fait
# https://cloud.google.com/sdk/docs/install

# Se connecter
gcloud auth login

# Définir le projet par défaut
gcloud config set project YOUR_PROJECT_ID
```

## 📝 **Configuration**

### 1. **Modifier terraform.tfvars**
```hcl
# Dans terraform/environments/gcp-complete/terraform.tfvars
gcp_project_id = "portfolio-gcp-123456"  # 👈 VOTRE PROJECT ID !
```

### 2. **Initialiser Terraform**
```bash
cd terraform/environments/gcp-complete
terraform init
```

### 3. **Déployer l'infrastructure**
```bash
terraform plan
terraform apply
```

## 🎯 **Résultat attendu :**
- ✅ **GCS Bucket** : State Terraform
- ✅ **Artifact Registry** : Repository Docker  
- ✅ **Cloud Run** : Application déployée
- ✅ **URL GCP** : `https://portfolio-prod-app-xxx-uw.a.run.app`

## 🚀 **Étapes suivantes :**
1. **Tester l'URL Cloud Run**
2. **Pusher l'image Docker**
3. **Valider le fonctionnement**
4. **Attendre AWS + domaine**
5. **Configurer domaine sur GCP**

**Prêt à commencer ?** 🎯