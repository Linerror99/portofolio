# 📂 Guide de Placement des Fichiers

## ✅ Étapes Complétées

1. ✅ **Supabase complètement supprimé** (pas besoin de base de données externe)
2. ✅ **Tech stack personnalisé** (12 technologies : HTML, CSS, JS, Tailwind, React, Vite, Node, Python, AWS, GCP, Docker, Terraform)
3. ✅ **Informations personnalisées** :
   - Nom : Laurent DJOSSOU
   - Email : djossou628@gmail.com
   - GitHub : https://github.com/Linerror99
   - LinkedIn : https://www.linkedin.com/in/laurent-djossou-ab2493240
   - Titre : "Cloud & DevOps Engineer"
   - Années d'expérience : calculées automatiquement depuis 2022
4. ✅ **Traduction française** (tous les textes traduits)
5. ✅ **localStorage** pour les données (pas de backend nécessaire)

---

## 📁 Où Placer Tes Fichiers du Dossier "old"

### 1. **Photo de Profil** (About Section)
**Emplacement :** `app/public/Photo.jpg`

**Actions :**
- Prends ta photo de profil du dossier "old"
- Renomme-la en `Photo.jpg`
- Place-la dans `app/public/`

**Recommandations :**
- Format : JPG ou PNG
- Dimensions idéales : 500x500px (carré)
- Poids : < 500 KB

---

### 2. **Screenshot du Projet Portfolio**
**Emplacement :** `app/public/projects/project-portfolio.jpg`

**Actions :**
- Prends le screenshot de ton projet portfolio du dossier "old"
- Renomme-le en `project-portfolio.jpg`
- Place-le dans `app/public/projects/`

**Recommandations :**
- Format : JPG ou PNG
- Dimensions idéales : 1200x800px (ratio 3:2)
- Poids : < 1 MB
- Capture : Vue d'ensemble de ton portfolio déployé

---

### 3. **Certificats** (3 fichiers)
**Emplacement :** `app/public/certificates/`

**Actions :**
- Prends tes 3 certificats du dossier "old"
- Renomme-les en :
  - `cert1.jpg`
  - `cert2.jpg`
  - `cert3.jpg`
- Place-les dans `app/public/certificates/`

**Recommandations :**
- Format : JPG ou PNG
- Dimensions : Haute résolution (minimum 1000px de largeur)
- Poids : < 500 KB chacun
- Si PDF : convertis-les en images avec https://www.ilovepdf.com/pdf_to_jpg

---

### 4. **Icônes Tech Stack** (12 fichiers SVG)
**Emplacement :** `app/public/icons/`

**Fichiers déjà présents :**
Les icônes sont déjà créées (simples SVG). Si tu veux les remplacer par de vraies icônes depuis ton dossier "old", nomme-les :

- `html.svg`
- `css.svg`
- `javascript.svg`
- `tailwind.svg`
- `reactjs.svg`
- `vite.svg`
- `nodejs.svg`
- `python.svg`
- `aws.svg`
- `gcp.svg`
- `docker.svg`
- `terraform.svg`

**Recommandations :**
- Format : **SVG uniquement** (préféré pour la scalabilité)
- Alternative : PNG avec fond transparent
- Dimensions : 128x128px ou vectoriel
- Sources d'icônes gratuites :
  - https://simpleicons.org/ (logos officiels SVG)
  - https://devicon.dev/ (icônes dev)

---

### 5. **CV PDF**
**Emplacement :** `app/public/cv/CV_Laurent_DJOSSOU.pdf`

**Actions :**
- Prends ton CV du dossier "old"
- Renomme-le en `CV_Laurent_DJOSSOU.pdf`
- Place-le dans `app/public/cv/`

**Recommandations :**
- Format : **PDF uniquement**
- Poids : < 2 MB
- Nom de fichier : exactement `CV_Laurent_DJOSSOU.pdf`

---

## 🔧 Modification des Données du Projet (Optionnel)

Si tu veux personnaliser les détails de ton projet, édite :

**Fichier :** `app/src/Pages/Portofolio.jsx`

**Lignes 133-145 :**
```javascript
const initialProjects = [
  {
    id: 1,
    Img: "/projects/project-portfolio.jpg",
    Title: "Infrastructure Multi-Cloud Portfolio",  // ← Change ici
    Description: "Portfolio déployé sur AWS ECS et GCP Cloud Run avec Terraform pour l'IaC",  // ← Change ici
    Link: "https://ldjossou.com"  // ← Change ici
  }
];
```

**Pour ajouter plus de projets :**
```javascript
const initialProjects = [
  {
    id: 1,
    Img: "/projects/project-portfolio.jpg",
    Title: "Infrastructure Multi-Cloud Portfolio",
    Description: "Portfolio déployé sur AWS ECS et GCP Cloud Run",
    Link: "https://ldjossou.com"
  },
  {
    id: 2,
    Img: "/projects/project2.jpg",
    Title: "Ton Deuxième Projet",
    Description: "Description de ton projet",
    Link: "https://lien-demo.com"
  }
  // Ajoute autant de projets que nécessaire
];
```

---

## 🎨 Modification des Certificats (Optionnel)

**Fichier :** `app/src/Pages/Portofolio.jsx`

**Lignes 147-151 :**
```javascript
const initialCertificates = [
  { id: 1, Img: "/certificates/cert1.jpg" },
  { id: 2, Img: "/certificates/cert2.jpg" },
  { id: 3, Img: "/certificates/cert3.jpg" }
];
```

**Pour ajouter/supprimer des certificats :**
- Ajoute simplement une nouvelle ligne avec `id` incrémenté
- Assure-toi que le fichier image existe dans `app/public/certificates/`

---

## 🚀 Après Avoir Placé Tous les Fichiers

### 1. Vérifie l'arborescence :
```
app/public/
├── Photo.jpg                        ✓ Ta photo
├── cv/
│   └── CV_Laurent_DJOSSOU.pdf      ✓ Ton CV
├── projects/
│   └── project-portfolio.jpg        ✓ Screenshot projet
├── certificates/
│   ├── cert1.jpg                    ✓ Certificat 1
│   ├── cert2.jpg                    ✓ Certificat 2
│   └── cert3.jpg                    ✓ Certificat 3
└── icons/
    ├── html.svg                     ✓ 12 icônes
    ├── css.svg
    ├── javascript.svg
    ├── tailwind.svg
    ├── reactjs.svg
    ├── vite.svg
    ├── nodejs.svg
    ├── python.svg
    ├── aws.svg
    ├── gcp.svg
    ├── docker.svg
    └── terraform.svg
```

### 2. Relance l'application :
```bash
npm run dev
```

### 3. Ouvre dans le navigateur :
```
http://localhost:5173/
```

### 4. Teste tous les éléments :
- ✅ Photo de profil affichée dans About
- ✅ Screenshot du projet visible dans Portfolio
- ✅ 3 certificats cliquables avec modal d'agrandissement
- ✅ 12 icônes tech stack affichées
- ✅ Bouton "Télécharger CV" fonctionne

---

## ⚠️ Notes Importantes

1. **Noms de fichiers exacts** : Les noms doivent correspondre exactement (majuscules/minuscules)
2. **Chemins relatifs** : Tous les chemins commencent par `/` (ex: `/Photo.jpg`, `/projects/...`)
3. **Formats supportés** :
   - Images : JPG, PNG, WebP, SVG
   - Documents : PDF uniquement
4. **Clear Cache** : Si les images ne s'affichent pas après placement, vide le cache du navigateur (Ctrl+Shift+R)

---

## 📝 Checklist Finale

Avant de dire "c'est bon" :

- [ ] Photo de profil placée (`Photo.jpg`)
- [ ] Screenshot projet placé (`project-portfolio.jpg`)
- [ ] 3 certificats placés (`cert1.jpg`, `cert2.jpg`, `cert3.jpg`)
- [ ] 12 icônes tech stack placées (ou conservé les SVG existants)
- [ ] CV PDF placé (`CV_Laurent_DJOSSOU.pdf`)
- [ ] Application relancée (`npm run dev`)
- [ ] Tous les éléments visuels affichés correctement
- [ ] Aucune image "cassée" (404)
- [ ] Bouton "Télécharger CV" fonctionne

---

## 🆘 Problèmes Courants

### Image ne s'affiche pas
- Vérifie le nom exact du fichier (case-sensitive)
- Vérifie l'emplacement dans `app/public/`
- Vide le cache (Ctrl+Shift+R)
- Vérifie la console du navigateur (F12)

### CV ne se télécharge pas
- Vérifie que le fichier est bien un PDF
- Vérifie le nom : `CV_Laurent_DJOSSOU.pdf`
- Vérifie l'emplacement : `app/public/cv/`

### Certificats ne s'agrandissent pas
- Vérifie que les fichiers existent
- Vérifie la console pour les erreurs JavaScript

---

**Quand tu auras placé tous les fichiers, dis-moi et je vérifierai avec toi !** 🚀
