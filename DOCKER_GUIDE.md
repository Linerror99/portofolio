# 🐳 Guide Docker - Portfolio Laurent DJOSSOU

Guide complet pour développer et tester le portfolio en local avec Docker.

---

## 📋 Prérequis

- **Docker Desktop** installé : https://www.docker.com/products/docker-desktop
- **Docker Compose** (inclus dans Docker Desktop)

Vérifier l'installation :
```bash
docker --version
docker-compose --version
```

---

## 🚀 Démarrage Rapide

### Option 1 : Mode Développement (Recommandé) 🔥

**Hot Reload activé** - Les modifications de code sont automatiquement rechargées

```bash
# Démarrer le serveur de développement
docker-compose up dev

# Accéder à l'application
# → http://localhost:5173
```

**Avantages** :
- ✅ Hot Module Replacement (HMR)
- ✅ Fast Refresh
- ✅ Logs en temps réel
- ✅ Debugging facile

---

### Option 2 : Mode Production 🚀

**Build optimisé** - Comme en production (Nginx)

```bash
# Build et démarrer Nginx
docker-compose up prod

# Accéder à l'application
# → http://localhost:8080
```

**Avantages** :
- ✅ Build optimisé (minification, tree-shaking)
- ✅ Performance maximale
- ✅ Serveur Nginx comme en production
- ✅ Tester avant déploiement

---

## 🛠️ Commandes Utiles

### Démarrage

```bash
# Mode développement (hot reload)
docker-compose up dev

# Mode production (Nginx)
docker-compose up prod

# En arrière-plan (detached mode)
docker-compose up -d dev

# Voir les logs
docker-compose logs -f dev
```

### Build

```bash
# Rebuild l'image (forcer rebuild)
docker-compose build dev

# Rebuild sans cache
docker-compose build --no-cache dev

# Build production
docker-compose build prod
```

### Gestion des conteneurs

```bash
# Arrêter les conteneurs
docker-compose down

# Arrêter et supprimer les volumes
docker-compose down -v

# Lister les conteneurs actifs
docker-compose ps

# Redémarrer un service
docker-compose restart dev
```

### Debugging

```bash
# Entrer dans le conteneur dev
docker-compose exec dev sh

# Voir les logs en temps réel
docker-compose logs -f dev

# Inspecter le réseau
docker network inspect portfolio-network

# Voir l'utilisation des ressources
docker stats portfolio-dev
```

---

## 📁 Structure Docker

```
portofolio/
├── docker-compose.yml          # Orchestration des services
├── app/
│   ├── Dockerfile             # Production (Nginx)
│   ├── Dockerfile.dev         # Développement (Vite)
│   ├── .dockerignore          # Fichiers exclus
│   ├── nginx.conf             # Config Nginx
│   └── src/                   # Code source (monté en volume en dev)
└── DOCKER_GUIDE.md            # Ce fichier
```

---

## 🔧 Configuration

### Ports exposés

| Service | Port Local | Port Conteneur | Description |
|---------|------------|----------------|-------------|
| **dev** | 5173 | 5173 | Vite dev server |
| **prod** | 8080 | 8080 | Nginx production |

### Volumes montés (mode dev)

```yaml
- ./app/src:/app/src              # Code source (hot reload)
- ./app/public:/app/public        # Assets publics
- ./app/index.html:/app/index.html
- ./app/vite.config.js:/app/vite.config.js
```

Les modifications dans `src/` sont **automatiquement détectées** !

---

## 🐛 Troubleshooting

### Problème : Port déjà utilisé

**Erreur** : `Bind for 0.0.0.0:5173 failed: port is already allocated`

**Solution** :
```bash
# Trouver le processus utilisant le port
# Windows
netstat -ano | findstr :5173

# Linux/Mac
lsof -i :5173

# Arrêter le processus ou changer le port dans docker-compose.yml
ports:
  - "3000:5173"  # Utiliser le port 3000 au lieu de 5173
```

---

### Problème : Hot Reload ne fonctionne pas

**Cause** : Problème de polling sur Windows

**Solution** : Ajouter dans `vite.config.js` :
```javascript
export default defineConfig({
  server: {
    watch: {
      usePolling: true,  // Activer le polling pour Windows
    },
    hmr: {
      host: 'localhost',
    }
  }
})
```

Puis rebuild :
```bash
docker-compose down
docker-compose build dev
docker-compose up dev
```

---

### Problème : Build échoue

**Erreur** : `npm ERR! peer dependencies conflict`

**Solution** :
```bash
# Rebuild sans cache
docker-compose build --no-cache dev

# Ou supprimer node_modules et rebuilder
docker-compose down -v
docker-compose build --no-cache dev
docker-compose up dev
```

---

### Problème : Conteneur démarre mais app inaccessible

**Vérifications** :

1. **Vérifier que le conteneur tourne** :
```bash
docker-compose ps
```

2. **Vérifier les logs** :
```bash
docker-compose logs dev
```

3. **Vérifier le health check** :
```bash
docker inspect portfolio-dev | grep Health
```

4. **Tester depuis le conteneur** :
```bash
docker-compose exec dev wget -O- http://localhost:5173
```

---

### Problème : Erreur de permissions

**Erreur** : `EACCES: permission denied`

**Solution** :
```bash
# Arrêter les conteneurs
docker-compose down

# Supprimer les volumes
docker volume rm portfolio-node-modules

# Rebuilder
docker-compose build --no-cache dev
docker-compose up dev
```

---

## 🔄 Workflow de Développement

### 1. Démarrer le développement

```bash
# Terminal 1 : Démarrer le serveur dev
docker-compose up dev
```

### 2. Modifier le code

```bash
# Éditer les fichiers dans app/src/
# Les modifications sont automatiquement rechargées dans le navigateur
code app/src/Pages/Portofolio.jsx
```

### 3. Tester en production

```bash
# Arrêter le mode dev
docker-compose down

# Démarrer en mode production
docker-compose up prod

# Tester sur http://localhost:8080
```

### 4. Commit et push

```bash
# Arrêter les conteneurs
docker-compose down

# Git workflow
git add .
git commit -m "feat: nouveau projet ajouté"
git push origin main
```

---

## 📊 Comparaison Dev vs Prod

| Caractéristique | Mode Dev | Mode Prod |
|----------------|----------|-----------|
| **Port** | 5173 | 8080 |
| **Serveur** | Vite | Nginx |
| **Hot Reload** | ✅ Oui | ❌ Non |
| **Build Time** | ~30s | ~2min |
| **Optimisations** | ❌ Minimal | ✅ Complet |
| **Taille Image** | ~500MB | ~50MB |
| **Usage RAM** | ~300MB | ~20MB |
| **Debugging** | ✅ Facile | ❌ Limité |

---

## 🎯 Best Practices

### Développement

1. **Toujours utiliser le mode dev** pour coder
2. **Ne pas committer node_modules** (dans .dockerignore)
3. **Tester en mode prod** avant de déployer
4. **Utiliser les logs** pour debugger : `docker-compose logs -f`

### Production

1. **Tester le build prod localement** avant CI/CD
2. **Vérifier le health check** : doit être ✅ healthy
3. **Optimiser les images** : utiliser `.dockerignore`
4. **Scanner les vulnérabilités** : `docker scan portfolio-prod`

---

## 🚀 Déploiement

Une fois testé localement avec Docker Compose :

```bash
# 1. Tester en prod local
docker-compose up prod

# 2. Vérifier que tout fonctionne
curl http://localhost:8080/health

# 3. Commit et push
git add .
git commit -m "feat: ready for deployment"
git push origin main

# 4. Le CI/CD se déclenche automatiquement
# → Build Docker
# → Push vers GCP Artifact Registry
# → Deploy sur Cloud Run
```

---

## 📚 Ressources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Vite Documentation](https://vitejs.dev/)
- [Nginx Documentation](https://nginx.org/en/docs/)

---

## 🆘 Support

En cas de problème :

1. **Vérifier les logs** : `docker-compose logs -f dev`
2. **Consulter ce guide** : Section Troubleshooting
3. **Rebuilder sans cache** : `docker-compose build --no-cache`
4. **Ouvrir une issue** sur GitHub

---

**Bon développement ! 🎉**

```bash
# Commande rapide pour démarrer
docker-compose up dev
```

**Dernière mise à jour** : Novembre 2025  
**Auteur** : Laurent DJOSSOU
