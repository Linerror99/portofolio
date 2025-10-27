# 📦 Guide d'Ajout des Images - Portfolio V2

## 🎯 Vue d'ensemble

Votre portfolio nécessite 3 types d'images :
1. **Screenshot du projet** (1 image)
2. **Certificats** (3 images)
3. **Icônes technologies** (12 icônes SVG)

---

## 📸 1. Screenshot du Projet

### Emplacement
`app/public/projects/project-portfolio.jpg`

### Spécifications
- **Format** : JPG ou PNG
- **Dimensions recommandées** : 1200x800px (ratio 16:9)
- **Poids maximum** : 500KB (optimisez avec [TinyPNG](https://tinypng.com))
- **Contenu** : Capture d'écran de votre portfolio en action

### Comment faire
1. Ouvrez votre portfolio dans un navigateur
2. Faites une capture d'écran (Windows: `Win + Shift + S`)
3. Optimisez l'image sur TinyPNG
4. Renommez en `project-portfolio.jpg`
5. Placez dans `app/public/projects/`

---

## 🏆 2. Certificats (3 images)

### Emplacement
```
app/public/certificates/
  ├── cert1.jpg
  ├── cert2.jpg
  └── cert3.jpg
```

### Spécifications
- **Format** : JPG ou PNG
- **Dimensions** : Format original du certificat
- **Poids** : Max 1MB par certificat
- **Qualité** : Haute résolution pour zoom modal

### Comment faire
1. Scannez ou téléchargez vos certificats PDF/images
2. Si PDF, convertissez en JPG via [PDF to JPG](https://www.pdf2jpg.net/)
3. Optimisez sur TinyPNG
4. Renommez en `cert1.jpg`, `cert2.jpg`, `cert3.jpg`
5. Placez dans `app/public/certificates/`

---

## 🎨 3. Icônes Technologies (12 icônes)

### Emplacement
```
app/public/icons/
  ├── html.svg
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

### Spécifications
- **Format** : SVG (de préférence) ou PNG
- **Dimensions** : 64x64px ou 128x128px
- **Fond** : Transparent
- **Style** : Logo officiel de chaque technologie

### Sources recommandées

#### Option 1 : DevIcon (Recommandé ⭐)
1. Visitez [devicon.dev](https://devicon.dev/)
2. Cherchez chaque technologie
3. Téléchargez la version SVG "plain" ou "original"
4. Renommez avec le nom exact ci-dessus

#### Option 2 : Simple Icons
1. Visitez [simpleicons.org](https://simpleicons.org/)
2. Cherchez la technologie
3. Cliquez sur "Copy SVG"
4. Créez un fichier `.svg` et collez le code

#### Option 3 : SVG Repo
1. Visitez [svgrepo.com](https://www.svgrepo.com/)
2. Cherchez "html icon", "css icon", etc.
3. Téléchargez le SVG
4. Renommez correctement

### Liste de téléchargement rapide

| Technologie | Lien direct DevIcon |
|-------------|---------------------|
| HTML | `html5-original.svg` |
| CSS | `css3-original.svg` |
| JavaScript | `javascript-original.svg` |
| Tailwind | `tailwindcss-plain.svg` |
| React | `react-original.svg` |
| Vite | `vite-original.svg` |
| Node.js | `nodejs-original.svg` |
| Python | `python-original.svg` |
| AWS | `amazonwebservices-original-wordmark.svg` |
| GCP | `googlecloud-original.svg` |
| Docker | `docker-original.svg` |
| Terraform | `terraform-original.svg` |

---

## ✅ Checklist de validation

### Avant de lancer l'application

- [ ] Screenshot du projet ajouté dans `/projects/`
- [ ] 3 certificats ajoutés dans `/certificates/`
- [ ] 12 icônes SVG ajoutées dans `/icons/`
- [ ] Toutes les images sont optimisées (< 500KB)
- [ ] Les noms de fichiers correspondent exactement

### Test de vérification

Lancez l'application :
```bash
npm run dev
```

Vérifiez :
1. **Section Projects** : Le screenshot du projet s'affiche
2. **Section Certificates** : Les 3 certificats s'affichent en grille
3. **Section Tech Stack** : Les 12 icônes sont visibles
4. **Clic sur certificat** : Le modal d'agrandissement fonctionne
5. **Bouton Details** : Redirige vers la page de détails du projet

---

## 🚨 Problèmes courants

### Images ne s'affichent pas
- Vérifiez les noms de fichiers (sensible à la casse)
- Assurez-vous que les images sont dans `/public/`
- Videz le cache du navigateur (`Ctrl + F5`)

### Icônes trop grandes/petites
- Utilisez des SVG pour un meilleur rendu
- Les dimensions sont gérées par Tailwind CSS

### Certificats flous dans le modal
- Utilisez des images haute résolution
- Format JPG avec qualité 85-90%

---

## 📝 Pour plus tard (optionnel)

Quand vous ajouterez plus de projets/certificats :

1. Modifiez `initialProjects` dans `PortfolioSection.jsx`
2. Ajoutez les nouvelles images dans les dossiers correspondants
3. Incrémentez les IDs (id: 2, id: 3, etc.)
4. Le bouton "See More" apparaîtra automatiquement si > 3 éléments

---

## 🎉 C'est tout !

Une fois ces images ajoutées, votre portfolio sera complet et prêt à être déployé ! 🚀

**Questions ?** Modifiez `PortfolioSection.jsx` pour personnaliser davantage.
