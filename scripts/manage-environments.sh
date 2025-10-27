#!/bin/bash
# ============================================================================
# ENVIRONMENT MANAGEMENT - Gestion intelligente des ressources
# ============================================================================
# Script pour gérer manuellement les environnements AWS/GCP

set -e

# Configuration
AWS_REGION="us-west-1"
GCP_REGION="us-west1" 
GCP_PROJECT_ID="portfolio-test-476200"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# FONCTIONS UTILITAIRES
# ============================================================================
print_header() {
    echo -e "${BLUE}============================================================================${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}============================================================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ============================================================================
# FONCTIONS AWS
# ============================================================================
aws_status() {
    print_header "AWS ECS STATUS"
    
    cd terraform/environments/aws-complete
    
    if [ ! -f "terraform.tfstate" ] && [ ! -f ".terraform/terraform.tfstate" ]; then
        print_warning "Infrastructure AWS non initialisée"
        return 1
    fi
    
    terraform init -input=false > /dev/null 2>&1
    
    # Vérifier si le service ECS existe
    DESIRED_COUNT=$(terraform output -raw ecs_desired_count 2>/dev/null || echo "0")
    ALB_URL=$(terraform output -raw load_balancer_url 2>/dev/null || echo "N/A")
    
    echo "🎯 Desired Count: $DESIRED_COUNT"
    echo "🌐 Load Balancer: $ALB_URL"
    
    if [ "$DESIRED_COUNT" -gt "0" ]; then
        print_success "AWS ECS is ACTIVE (Running: $DESIRED_COUNT instances)"
        
        # Test de santé
        if [ "$ALB_URL" != "N/A" ]; then
            if curl -f -s "$ALB_URL/health" > /dev/null 2>&1; then
                print_success "Health check: OK"
            else
                print_warning "Health check: FAILED"
            fi
        fi
    else
        print_warning "AWS ECS is STOPPED (Cost optimization)"
    fi
    
    cd - > /dev/null
}

aws_start() {
    print_header "STARTING AWS ECS"
    
    cd terraform/environments/aws-complete
    
    terraform init -input=false
    terraform apply -var="desired_count=1" -auto-approve
    
    print_success "AWS ECS démarré"
    
    # Attendre et tester
    print_warning "Attente du démarrage (30s)..."
    sleep 30
    aws_status
    
    cd - > /dev/null
}

aws_stop() {
    print_header "STOPPING AWS ECS"
    
    cd terraform/environments/aws-complete
    
    terraform init -input=false
    terraform apply -var="desired_count=0" -auto-approve
    
    print_success "AWS ECS arrêté (économie: ~65€/mois)"
    
    cd - > /dev/null
}

# ============================================================================
# FONCTIONS GCP
# ============================================================================
gcp_status() {
    print_header "GCP CLOUD RUN STATUS"
    
    cd terraform/environments/gcp-complete
    
    if [ ! -f ".terraform/terraform.tfstate" ]; then
        print_warning "Infrastructure GCP non initialisée"
        return 1
    fi
    
    terraform init -input=false > /dev/null 2>&1
    
    CLOUD_RUN_URL=$(terraform output -raw cloud_run_url 2>/dev/null || echo "N/A")
    SERVICE_STATUS=$(gcloud run services describe portfolio-prod-portfolio-app \
                    --region=$GCP_REGION --format="value(status.conditions[0].status)" 2>/dev/null || echo "Unknown")
    
    echo "🌐 Cloud Run URL: $CLOUD_RUN_URL"
    echo "📊 Service Status: $SERVICE_STATUS"
    
    if [ "$SERVICE_STATUS" = "True" ] && [ "$CLOUD_RUN_URL" != "N/A" ]; then
        print_success "GCP Cloud Run is ACTIVE"
        
        # Test de santé
        if curl -f -s "$CLOUD_RUN_URL/health" > /dev/null 2>&1; then
            print_success "Health check: OK"
        else
            print_warning "Health check: FAILED"
        fi
    else
        print_warning "GCP Cloud Run is NOT ACTIVE"
    fi
    
    cd - > /dev/null
}

gcp_deploy() {
    print_header "DEPLOYING GCP CLOUD RUN"
    
    cd terraform/environments/gcp-complete
    
    terraform init -input=false
    terraform plan -out=tfplan
    terraform apply tfplan
    
    print_success "GCP Cloud Run déployé"
    
    # Attendre et tester  
    print_warning "Attente du déploiement (30s)..."
    sleep 30
    gcp_status
    
    cd - > /dev/null
}

# ============================================================================
# FONCTION PRINCIPALE
# ============================================================================
show_menu() {
    print_header "PORTFOLIO CI/CD - ENVIRONMENT MANAGER"
    echo "💰 Stratégie: Un seul environnement actif pour optimiser les coûts"
    echo ""
    echo "🔍 Status Commands:"
    echo "  1) AWS Status"
    echo "  2) GCP Status" 
    echo "  3) Both Status"
    echo ""
    echo "🚀 Management Commands:"
    echo "  4) Start AWS (Stop GCP recommended)"
    echo "  5) Deploy GCP (Stop AWS recommended)"
    echo "  6) Stop AWS (Save ~65€/month)"
    echo ""
    echo "⚡ Quick Actions:"
    echo "  7) Switch to AWS (Stop GCP + Start AWS)"
    echo "  8) Switch to GCP (Stop AWS + Deploy GCP)"
    echo "  9) Stop All (Maximum savings)"
    echo ""
    echo "  0) Exit"
    echo ""
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================
main() {
    if [ ! -d "terraform" ]; then
        print_error "Veuillez exécuter ce script depuis la racine du projet"
        exit 1
    fi
    
    while true; do
        show_menu
        read -p "Choisissez une option: " choice
        
        case $choice in
            1) aws_status ;;
            2) gcp_status ;;
            3) aws_status; echo ""; gcp_status ;;
            4) aws_start ;;
            5) gcp_deploy ;;
            6) aws_stop ;;
            7) 
                print_header "SWITCHING TO AWS"
                gcp_status
                aws_start
                ;;
            8)
                print_header "SWITCHING TO GCP"  
                aws_stop
                gcp_deploy
                ;;
            9)
                print_header "STOPPING ALL ENVIRONMENTS"
                aws_stop
                print_success "Tous les environnements arrêtés - Économie maximale!"
                ;;
            0) 
                print_success "Au revoir!"
                exit 0 
                ;;
            *)
                print_error "Option invalide"
                ;;
        esac
        
        echo ""
        read -p "Appuyez sur Entrée pour continuer..."
        clear
    done
}

# Lancement
main "$@"