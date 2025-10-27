# 🚀 Guide de Déploiement Automatique

## 📌 Vue d'ensemble

Votre portfolio utilise **GitHub Actions** pour un déploiement **100% automatique** sur GCP Cloud Run.

---

## 🔄 Déclenchement Automatique

### ✅ **Déploiement PRODUCTION (GCP Cloud Run)**
**Branche:** `main`  
**Workflow:** `.github/workflows/production-gcp.yml`

#### Quand le déploiement se lance :
```bash
# Automatiquement quand vous PUSH sur main et que ces fichiers changent :
- app/**                              # Tout changement dans le code
- terraform/environments/gcp-complete/**  # Changement infra GCP
- terraform/modules/**                # Changement modules Terraform
- .github/workflows/production-gcp.yml    # Changement workflow
```

#### Ce qui se passe automatiquement :
1. **🛑 Arrêt AWS ECS** (économie ~65€/mois)
2. **🏗️ Build de l'image Docker**
   - Multi-stage build (Node.js + Nginx)
   - Tag: `us-west1-docker.pkg.dev/portfolio-test-476200/portfolio-images/app:latest`
3. **📤 Push vers Artifact Registry** (GCP)
4. **🚀 Déploiement sur Cloud Run**
   - Service: `portfolio-app`
   - URL: `https://portfolio-app-[id].us-west1.run.app`
   - Redémarrage automatique avec la nouvelle image
5. **🌐 Mise à jour DNS** (si configuré)
   - Domaine: `ldjossou.com` → Cloud Run

---

### ✅ **Déploiement STAGING (AWS ECS)**
**Branche:** `staging` ou `develop`  
**Workflow:** `.github/workflows/staging-aws.yml`

#### Quand le déploiement se lance :
```bash
# Automatiquement quand vous PUSH sur staging/develop et que ces fichiers changent :
- app/**
- terraform/environments/aws-complete/**
```

---

## 🎯 Workflow Complet de Déploiement

### 📝 **Étape par étape**

```bash
# 1️⃣ Vous faites vos modifications localement
cd app/src/Pages
# ... modifications de Home.jsx, Contact.jsx, etc.

# 2️⃣ Vous commitez et pushez
git add .
git commit -m "feat: mise à jour page contact et tech stack"
git push origin main

# 3️⃣ GitHub Actions détecte le push automatiquement
# ✅ Workflow production-gcp.yml se lance

# 4️⃣ Build Docker (2-3 minutes)
# - npm install (avec --legacy-peer-deps)
# - npm run build (génère dist/)
# - Création image nginx:alpine avec dist/

# 5️⃣ Push vers Artifact Registry (30 secondes)
# - Image taguée avec SHA du commit
# - Image taguée avec :latest

# 6️⃣ Déploiement Cloud Run (1-2 minutes)
# - Nouvelle révision créée
# - Rolling update (0 downtime)
# - Trafic basculé progressivement

# 7️⃣ Site live ! (Total: 4-6 minutes)
# ✅ https://ldjossou.com mise à jour
```

---

## 🔑 **Secrets GitHub nécessaires**

Vérifiez que ces secrets sont configurés dans votre repo :

### Settings → Secrets and variables → Actions

```yaml
# GCP (Production)
GCP_SERVICE_ACCOUNT_KEY: <Clé JSON du service account GCP>

# AWS (Staging - optionnel)
AWS_ACCESS_KEY_ID: <ID accès AWS>
AWS_SECRET_ACCESS_KEY: <Clé secrète AWS>
```

---

## 🧪 **Tester le déploiement**

### **Option 1: Déploiement automatique (recommandé)**
```bash
# Modifiez un fichier
echo "# Update" >> app/README.md

# Commitez et pushez
git add .
git commit -m "test: déploiement automatique"
git push origin main

# Suivez le déploiement sur GitHub
# https://github.com/Linerror99/portofolio/actions
```

### **Option 2: Déploiement manuel**
```bash
# Sur GitHub : Actions → Deploy Production (GCP)
# Cliquez "Run workflow" → Run workflow
```

---

## 📊 **Monitoring du déploiement**

### ✅ **GitHub Actions**
```
https://github.com/Linerror99/portofolio/actions
```
- Voir les logs en temps réel
- Status de chaque étape
- Durée d'exécution

### ✅ **GCP Cloud Run Console**
```
https://console.cloud.google.com/run?project=portfolio-test-476200
```
- Révisions déployées
- Métriques (requêtes, latence, erreurs)
- Logs d'application

### ✅ **Vérification du site**
```bash
# Test direct
curl https://ldjossou.com

# Avec headers
curl -I https://ldjossou.com
```

---

## ⚙️ **Configuration actuelle**

### **Dockerfile** (`app/Dockerfile`)
```dockerfile
✅ Multi-stage build (Node:20-alpine + Nginx:alpine)
✅ npm ci --legacy-peer-deps (gestion dépendances)
✅ npm run build (génère dist/ optimisé)
✅ Nginx avec gzip, cache, security headers
✅ Healthcheck endpoint /health
✅ Port 8080 (non-privilégié)
✅ User non-root (sécurité)
```

### **nginx.conf**
```nginx
✅ SPA fallback (React Router)
✅ Gzip compression
✅ Cache static assets (1 an)
✅ Security headers (XSS, CSP, etc.)
✅ Health check /health
```

### **package.json**
```json
✅ Toutes dépendances à jour
✅ Build script: vite build
✅ Scripts optimisés
```

---

## 🔄 **Timeline de déploiement**

```
t=0s    : git push origin main
t=5s    : GitHub Actions détecte le push
t=10s   : Checkout code + Setup Docker
t=30s   : npm ci (installation dépendances)
t=2min  : npm run build (build production)
t=2m30s : Docker build + tag
t=3min  : Push vers Artifact Registry
t=4min  : Deploy Cloud Run (nouvelle révision)
t=5min  : Traffic routing (rolling update)
t=6min  : ✅ SITE LIVE avec dernières modifications !
```

---

## 💰 **Coûts estimés**

### **GCP Cloud Run (Production)**
- **Coût mensuel:** ~5-15€
- **Facturation:** À l'utilisation (requêtes + CPU + mémoire)
- **Avantage:** Scale to zero = pas de coût quand pas utilisé

### **AWS ECS (Staging - optionnel)**
- **Coût mensuel:** ~65€ (si actif 24/7)
- **Économie:** Workflow arrête automatiquement AWS quand GCP actif

---

## 🐛 **Troubleshooting**

### ❌ **Le workflow échoue**
```bash
# Vérifiez les logs GitHub Actions
# Causes fréquentes :
- Secrets manquants/expirés
- Erreur de build npm
- Quota GCP dépassé
- Permissions service account
```

### ❌ **Site pas mis à jour après déploiement**
```bash
# Videz le cache navigateur
Ctrl + Shift + R (Chrome/Firefox)

# Vérifiez la révision Cloud Run
gcloud run revisions list --service=portfolio-app --region=us-west1

# Testez en incognito
```

### ❌ **Image Docker ne build pas**
```bash
# Testez localement
cd app
docker build -t portfolio-test .
docker run -p 8080:8080 portfolio-test

# Vérifiez les logs
docker logs <container_id>
```

---

## 📚 **Commandes utiles**

### **Local**
```bash
# Build local
cd app
npm install --legacy-peer-deps
npm run build

# Preview du build
npm run preview

# Test Docker local
docker build -t portfolio-local .
docker run -p 8080:8080 portfolio-local
```

### **GCP**
```bash
# Lister les révisions Cloud Run
gcloud run revisions list --service=portfolio-app --region=us-west1

# Voir les logs en temps réel
gcloud run services logs read portfolio-app --region=us-west1 --follow

# Rollback vers révision précédente
gcloud run services update-traffic portfolio-app \
  --to-revisions=portfolio-app-00002-xxx=100 \
  --region=us-west1
```

---

## ✅ **Checklist avant déploiement**

- [ ] Tests locaux passent (`npm run dev`)
- [ ] Build fonctionne (`npm run build`)
- [ ] Pas d'erreurs dans la console
- [ ] Formulaire contact testé
- [ ] Images optimisées (< 500KB)
- [ ] Git commit avec message descriptif
- [ ] Branch à jour avec main

---

## 🎉 **Résumé**

**OUI, à chaque push sur `main` dans le dossier `app/`, votre portfolio est automatiquement :**

1. ✅ **Build** avec les dernières modifications
2. ✅ **Packagé** dans une image Docker optimisée  
3. ✅ **Déployé** sur Cloud Run (production)
4. ✅ **Accessible** sur https://ldjossou.com

**Durée totale:** 4-6 minutes ⚡

**Coût:** ~5-15€/mois 💰

**Disponibilité:** 99.95% (SLA Cloud Run) 🚀

---

## 📞 **Support**

- **GitHub Actions:** https://github.com/Linerror99/portofolio/actions
- **GCP Console:** https://console.cloud.google.com/run?project=portfolio-test-476200
- **Documentation:** https://cloud.google.com/run/docs
