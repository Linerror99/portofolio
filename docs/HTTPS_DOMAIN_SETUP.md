# Configuration HTTPS et Domaine Personnalisé

Ce guide explique comment configurer un domaine personnalisé avec HTTPS pour votre portfolio.

## 📋 Prérequis

1. **Domaine personnalisé** : Vous devez acheter un nom de domaine
2. **Accès à la gestion DNS** : Pouvoir modifier les nameservers chez votre registraire
3. **Infrastructure déployée** : Votre portfolio doit être fonctionnel en HTTP

## 🛒 1. Achat du Domaine

### Options recommandées :
- **`ldjossou.com`** - Professional, simple
- **`ldjossou.dev`** - Développeur, moderne  
- **`djossou.tech`** - Technique, tech-savvy

### Plateformes d'achat :
1. **AWS Route 53** (recommandé pour intégration)
   - Gestion DNS automatique
   - Prix : ~12-15€/an selon l'extension
   - Console AWS → Route 53 → Register Domain

2. **Namecheap** (économique)
   - Prix compétitifs
   - Interface simple
   - Configuration DNS manuelle requise

3. **Cloudflare** (fonctionnalités avancées)
   - CDN gratuit inclus
   - Protection DDoS
   - Configuration DNS manuelle requise

## ⚙️ 2. Configuration Terraform

### Variables à définir dans `terraform.tfvars` :

```hcl
# ============================================================================
# CONFIGURATION DOMAINE ET HTTPS
# ============================================================================

# Nom de domaine (sans www)
domain_name = "ldjossou.com"  # 👈 REMPLACER par votre domaine

# Créer une zone Route 53 hébergée (recommandé)
create_route53_zone = true

# Activer HTTPS avec certificat SSL
enable_https = true

# Créer automatiquement le certificat SSL
create_certificate = true
```

### Déploiement avec le domaine :

```bash
# 1. Mettre à jour la configuration
cd terraform/environments/aws-complete

# 2. Planifier les changements
terraform plan

# 3. Appliquer la configuration
terraform apply

# 4. Noter les nameservers Route 53
terraform output route53_name_servers
```

## 🌐 3. Configuration DNS

### Si vous avez acheté le domaine sur Route 53 :
✅ **Aucune action requise** - AWS gère automatiquement les nameservers.

### Si vous avez acheté le domaine ailleurs :

1. **Récupérer les nameservers Route 53** :
   ```bash
   terraform output route53_name_servers
   ```

2. **Configuration chez votre registraire** :
   
   **Namecheap :**
   - Dashboard → Domain List → Manage
   - Nameservers → Custom DNS
   - Ajouter les 4 nameservers Route 53

   **Cloudflare :**
   - Dashboard → Domain → DNS Settings
   - Nameservers → Custom
   - Ajouter les 4 nameservers Route 53

   **Autres registraires :**
   - Chercher "DNS Settings" ou "Nameservers"
   - Sélectionner "Custom" ou "Use custom nameservers"
   - Ajouter les 4 nameservers fournis par Route 53

## 🔒 4. Certificat SSL (Automatique)

Le certificat SSL est géré automatiquement par AWS Certificate Manager (ACM) :

- **Validation** : DNS automatique via Route 53
- **Renouvellement** : Automatique avant expiration
- **Coût** : Gratuit pour les certificats publics

## 📊 5. Vérification du Déploiement

### Tests à effectuer :

```bash
# 1. Vérifier la résolution DNS (peut prendre 24-48h)
nslookup ldjossou.com

# 2. Tester HTTP (doit rediriger vers HTTPS)
curl -I http://ldjossou.com

# 3. Tester HTTPS
curl -I https://ldjossou.com

# 4. Tester www
curl -I https://www.ldjossou.com
```

### Résultats attendus :
- ✅ HTTP → Redirect 301 vers HTTPS
- ✅ HTTPS → 200 OK avec certificat valide
- ✅ www.domain.com → fonctionne également

## ⏱️ 6. Temps de Propagation

| Étape | Délai |
|-------|--------|
| Déploiement Terraform | 5-10 minutes |
| Certificat SSL | 5-15 minutes |
| Propagation DNS | 1-24 heures |
| Propagation mondiale | 24-48 heures |

## 💰 7. Coûts Estimés

### Coûts additionnels avec domaine :

| Service | Coût mensuel | Coût annuel |
|---------|--------------|-------------|
| Domaine (.com) | ~1€ | ~12€ |
| Route 53 Zone | $0.50 | $6 |
| Certificat SSL | Gratuit | Gratuit |
| **Total supplémentaire** | **~1.50€** | **~18€** |

### Coût total avec HTTPS :
- **Infrastructure existante** : ~64-69€/mois
- **Domaine + DNS** : +1.50€/mois
- **Total** : ~65.50-70.50€/mois

## 🔧 8. URLs Finales

Après configuration complète :

```
✅ https://ldjossou.com           ← URL principale
✅ https://www.ldjossou.com       ← Alias www
🔄 http://ldjossou.com            ← Redirige vers HTTPS
🔄 http://www.ldjossou.com        ← Redirige vers HTTPS
```

## 🚨 9. Dépannage

### Problèmes courants :

**DNS ne résout pas :**
- Vérifier les nameservers chez le registraire
- Attendre 24-48h pour la propagation

**Certificat SSL en attente :**
- Vérifier que Route 53 gère le domaine
- La validation DNS est automatique

**Site inaccessible :**
- Vérifier les security groups AWS
- Tester d'abord l'URL ALB directe

### Commandes de diagnostic :

```bash
# Vérifier la configuration Terraform
terraform plan

# Voir les outputs
terraform output

# Vérifier les logs ECS
aws ecs describe-services --cluster portfolio-prod --services portfolio-prod-app
```

## 📚 10. Étapes Suivantes

Après configuration HTTPS :

1. **Sécurité** : Configurer Content Security Policy (CSP)
2. **Performance** : Ajouter CloudFront CDN
3. **Monitoring** : Configurer des alertes Route 53
4. **SEO** : Configurer des redirections canoniques
5. **Backup** : Exporter la zone DNS

---

**🎯 Objectif final :** Un portfolio professionnel accessible via `https://ldjossou.com` avec certificat SSL valide et redirection automatique HTTP→HTTPS.