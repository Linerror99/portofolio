# ================================
# STAGE 1: Builder
# ================================
FROM node:20-alpine AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY package.json package-lock.json* ./

# Installer les dépendances
# Utilise npm ci si package-lock.json existe, sinon npm install
# --legacy-peer-deps pour éviter les conflits de dépendances
RUN if [ -f package-lock.json ]; then npm ci --legacy-peer-deps; else npm install --legacy-peer-deps; fi

# Copier tout le code source
COPY . .

# Build de production
# Génère le dossier dist/ avec les fichiers optimisés
RUN npm run build

# ================================
# STAGE 2: Production avec Nginx
# ================================
FROM nginx:alpine AS production

# Métadonnées de l'image
LABEL maintainer="DevOps Portfolio"
LABEL description="Portfolio React+Vite servi par Nginx"

# Copier la configuration Nginx personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier les fichiers buildés depuis le stage builder
# Le dossier dist/ contient HTML, CSS, JS optimisés
COPY --from=builder /app/dist /usr/share/nginx/html

# Créer un utilisateur non-root pour la sécurité
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /usr/share/nginx/html && \
    chown -R nodejs:nodejs /var/cache/nginx && \
    chown -R nodejs:nodejs /var/log/nginx && \
    chown -R nodejs:nodejs /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nodejs:nodejs /var/run/nginx.pid

# Passer à l'utilisateur non-root
USER nodejs

# Exposer le port 8080 (port non-privilégié)
EXPOSE 8080

# Healthcheck pour vérifier que Nginx fonctionne
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

# Commande de démarrage
CMD ["nginx", "-g", "daemon off;"]
