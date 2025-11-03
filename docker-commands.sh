#!/bin/bash
# ============================================================================
# Scripts Docker - Portfolio
# ============================================================================
# Usage : source docker-commands.sh ou ./docker-commands.sh <command>
# ============================================================================

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ====================
# FONCTIONS UTILES
# ====================

# Démarrer le mode développement
dev() {
    echo -e "${GREEN}🚀 Démarrage du mode développement...${NC}"
    docker-compose up dev
}

# Démarrer le mode production
prod() {
    echo -e "${GREEN}🚀 Démarrage du mode production...${NC}"
    docker-compose up prod
}

# Démarrer en arrière-plan
dev-bg() {
    echo -e "${GREEN}🚀 Démarrage du mode développement (background)...${NC}"
    docker-compose up -d dev
    echo -e "${BLUE}✅ Serveur disponible sur http://localhost:5173${NC}"
}

prod-bg() {
    echo -e "${GREEN}🚀 Démarrage du mode production (background)...${NC}"
    docker-compose up -d prod
    echo -e "${BLUE}✅ Serveur disponible sur http://localhost:8080${NC}"
}

# Arrêter tous les conteneurs
stop() {
    echo -e "${YELLOW}🛑 Arrêt des conteneurs...${NC}"
    docker-compose down
    echo -e "${GREEN}✅ Conteneurs arrêtés${NC}"
}

# Rebuild complet
rebuild() {
    echo -e "${YELLOW}🔨 Rebuild complet (sans cache)...${NC}"
    docker-compose down -v
    docker-compose build --no-cache dev
    echo -e "${GREEN}✅ Rebuild terminé${NC}"
}

# Logs en temps réel
logs() {
    SERVICE=${1:-dev}
    echo -e "${BLUE}📋 Logs du service ${SERVICE}...${NC}"
    docker-compose logs -f $SERVICE
}

# Entrer dans le conteneur
shell() {
    SERVICE=${1:-dev}
    echo -e "${BLUE}🐚 Shell dans le conteneur ${SERVICE}...${NC}"
    docker-compose exec $SERVICE sh
}

# Nettoyer tout Docker
clean() {
    echo -e "${RED}🧹 Nettoyage complet de Docker...${NC}"
    read -p "⚠️  Supprimer tous les conteneurs, volumes et images ? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down -v
        docker system prune -af --volumes
        echo -e "${GREEN}✅ Nettoyage terminé${NC}"
    else
        echo -e "${YELLOW}❌ Annulé${NC}"
    fi
}

# Status des conteneurs
status() {
    echo -e "${BLUE}📊 Status des conteneurs${NC}"
    docker-compose ps
    echo ""
    echo -e "${BLUE}💾 Images Docker${NC}"
    docker images | grep portfolio
    echo ""
    echo -e "${BLUE}🌐 Réseaux${NC}"
    docker network ls | grep portfolio
}

# Health check
health() {
    SERVICE=${1:-dev}
    PORT=${2:-5173}
    
    echo -e "${BLUE}🏥 Health check du service ${SERVICE} sur le port ${PORT}...${NC}"
    
    if curl -s -f http://localhost:${PORT}/ > /dev/null; then
        echo -e "${GREEN}✅ Service ${SERVICE} est UP et répond${NC}"
    else
        echo -e "${RED}❌ Service ${SERVICE} ne répond pas${NC}"
        echo -e "${YELLOW}Vérifiez les logs : docker-compose logs ${SERVICE}${NC}"
    fi
}

# Ouvrir dans le navigateur
open-browser() {
    SERVICE=${1:-dev}
    
    if [ "$SERVICE" == "prod" ]; then
        URL="http://localhost:8080"
    else
        URL="http://localhost:5173"
    fi
    
    echo -e "${BLUE}🌐 Ouverture de ${URL}...${NC}"
    
    # Détecter l'OS
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        start $URL
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        open $URL
    else
        xdg-open $URL
    fi
}

# Afficher l'aide
help() {
    echo -e "${GREEN}==================================================${NC}"
    echo -e "${GREEN}  🐳 Docker Commands - Portfolio${NC}"
    echo -e "${GREEN}==================================================${NC}"
    echo ""
    echo -e "${BLUE}Commandes de base :${NC}"
    echo "  dev              Démarrer le mode développement"
    echo "  prod             Démarrer le mode production"
    echo "  dev-bg           Démarrer dev en arrière-plan"
    echo "  prod-bg          Démarrer prod en arrière-plan"
    echo "  stop             Arrêter tous les conteneurs"
    echo ""
    echo -e "${BLUE}Build et maintenance :${NC}"
    echo "  rebuild          Rebuild complet (sans cache)"
    echo "  clean            Nettoyer tout Docker"
    echo ""
    echo -e "${BLUE}Debugging :${NC}"
    echo "  logs [service]   Voir les logs (défaut: dev)"
    echo "  shell [service]  Entrer dans le conteneur"
    echo "  status           Voir le status des conteneurs"
    echo "  health [service] Vérifier le health check"
    echo ""
    echo -e "${BLUE}Utilitaires :${NC}"
    echo "  open-browser [service]  Ouvrir dans le navigateur"
    echo "  help             Afficher cette aide"
    echo ""
    echo -e "${YELLOW}Exemples :${NC}"
    echo "  ./docker-commands.sh dev"
    echo "  ./docker-commands.sh logs dev"
    echo "  ./docker-commands.sh shell prod"
    echo ""
}

# ====================
# MAIN
# ====================

# Si le script est sourcé, ne rien faire
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo -e "${GREEN}✅ Fonctions Docker chargées${NC}"
    echo -e "${YELLOW}Usage : dev, prod, stop, rebuild, logs, etc.${NC}"
    echo -e "${YELLOW}Pour voir toutes les commandes : help${NC}"
    return 0
fi

# Si le script est exécuté directement
COMMAND=${1:-help}

case $COMMAND in
    dev|d)
        dev
        ;;
    prod|p)
        prod
        ;;
    dev-bg|db)
        dev-bg
        ;;
    prod-bg|pb)
        prod-bg
        ;;
    stop|s)
        stop
        ;;
    rebuild|r)
        rebuild
        ;;
    logs|l)
        logs $2
        ;;
    shell|sh)
        shell $2
        ;;
    clean|c)
        clean
        ;;
    status|st)
        status
        ;;
    health|h)
        health $2 $3
        ;;
    open|o)
        open-browser $2
        ;;
    help|--help|-h|*)
        help
        ;;
esac
