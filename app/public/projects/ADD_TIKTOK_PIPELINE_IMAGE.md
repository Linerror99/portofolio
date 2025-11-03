# 📸 Instructions pour ajouter l'image du projet Pipeline Vidéo IA TikTok

## 🎯 Image requise

Vous devez ajouter une capture d'écran de votre projet dans :

```
app/public/projects/project-tiktok-pipeline.jpg
```

## 📋 Caractéristiques de l'image

- **Format** : JPG ou PNG
- **Dimensions recommandées** : 1200x800px (ratio 16:9)
- **Poids** : < 500 KB (optimisé)
- **Contenu** : Screenshot de l'interface frontend ou de la page d'accueil

## 🔗 Comment obtenir l'image

### Option 1 : Screenshot du site en production

1. Allez sur : https://pipeline-frontend-354616212471.us-central1.run.app/
2. Utilisez un outil de capture d'écran (Windows: Win+Shift+S, Mac: Cmd+Shift+4)
3. Capturez la page d'accueil ou l'interface principale

### Option 2 : Utiliser un outil en ligne

1. Allez sur https://www.screenshotmachine.com/
2. Entrez l'URL : `https://pipeline-frontend-354616212471.us-central1.run.app/`
3. Téléchargez le screenshot
4. Optimisez avec https://tinypng.com/ si > 500KB

### Option 3 : Screenshot local (si vous avez le code)

```bash
# Si vous avez le projet frontend en local
cd pipeline-frontend
npm run dev
# Ouvrir http://localhost:5173 et faire un screenshot
```

## 📂 Placement du fichier

Une fois l'image obtenue :

1. Renommez-la en : `project-tiktok-pipeline.jpg`
2. Placez-la dans : `app/public/projects/`
3. Structure finale :
   ```
   
   app/public/projects/
   ├── project-portfolio.jpg       ✅ Existant
   └── project-tiktok-pipeline.jpg  ⬅️ À ajouter
   ```

## 🧪 Vérification

Après avoir ajouté l'image, testez :

```bash
cd app
npm run dev
```

Allez dans la section **Portfolio** et vérifiez que :
- ✅ L'image du projet Pipeline Vidéo IA s'affiche
- ✅ Le titre et la description sont corrects
- ✅ Le bouton "Live Demo" fonctionne
- ✅ Le bouton "Details" affiche toutes les informations

## 🎨 Conseils pour une belle capture

- **Cadrez bien** : Montrez l'interface principale avec le formulaire
- **Qualité** : Prenez en résolution haute (1920x1080 minimum)
- **Contexte** : Incluez quelques éléments de design (logo, navigation)
- **Compressez** : Utilisez TinyPNG pour réduire le poids sans perte de qualité

## 📊 Informations du projet déjà configurées

✅ **Titre** : Pipeline Vidéo IA TikTok - Génération Automatisée  
✅ **Description** : Pipeline complète de génération automatique de vidéos TikTok/Shorts  
✅ **Live Demo** : https://pipeline-frontend-354616212471.us-central1.run.app/  
✅ **GitHub** : https://github.com/Linerror99Su/pipeline-video-tiktok  
✅ **Features** : 8 fonctionnalités détaillées  
✅ **Tech Stack** : 9 technologies listées  

## ❓ Questions fréquentes

### Le projet n'apparaît pas ?
- Vérifiez que le fichier s'appelle bien `project-tiktok-pipeline.jpg`
- Vérifiez qu'il est dans `app/public/projects/`
- Rechargez la page (Ctrl+F5)

### L'image est floue ?
- Prenez un screenshot en plus haute résolution
- Assurez-vous d'utiliser un format JPG de qualité 80-90%

### L'image est trop lourde (> 500KB) ?
- Utilisez https://tinypng.com/ pour compresser
- Ou convertissez en WebP : https://squoosh.app/

---

**Une fois l'image ajoutée, votre portfolio sera complet avec ce nouveau projet ! 🎉**
