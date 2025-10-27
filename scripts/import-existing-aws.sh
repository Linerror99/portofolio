#!/bin/bash
# ============================================================================
# IMPORT EXISTING AWS RESOURCES - Smart Import Script
# ============================================================================
# Ce script détecte et importe automatiquement les ressources AWS existantes
# dans l'état Terraform pour éviter les erreurs "already exists"

set -e

# Configuration
AWS_REGION="${AWS_REGION:-us-west-1}"
PROJECT_NAME="${PROJECT_NAME:-portfolio}"
ENVIRONMENT="${ENVIRONMENT:-prod}"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================================================${NC}"
echo -e "${BLUE}🔄 AWS Resources Import Script${NC}"
echo -e "${BLUE}============================================================================${NC}"

# ============================================================================
# FONCTION: Import avec gestion d'erreur
# ============================================================================
safe_import() {
    local resource_address=$1
    local resource_id=$2
    local resource_name=$3
    
    echo -e "${YELLOW}📦 Importing: $resource_name${NC}"
    
    if terraform import -input=false "$resource_address" "$resource_id" 2>/dev/null; then
        echo -e "${GREEN}✅ Successfully imported: $resource_name${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  Already imported or not found: $resource_name${NC}"
        return 0  # Continue même si déjà importé
    fi
}

# ============================================================================
# FONCTION: Vérifier si une ressource existe dans AWS
# ============================================================================
resource_exists() {
    local check_command=$1
    eval "$check_command" >/dev/null 2>&1
    return $?
}

echo ""
echo -e "${BLUE}🔍 Detecting existing AWS resources...${NC}"
echo ""

# ============================================================================
# 1. BACKEND STATE (S3 + DynamoDB)
# ============================================================================
echo -e "${BLUE}📦 Backend State Resources${NC}"

# S3 Bucket
S3_BUCKET="${PROJECT_NAME}-${ENVIRONMENT}-tfstate"
if resource_exists "aws s3api head-bucket --bucket $S3_BUCKET --region $AWS_REGION"; then
    safe_import "module.backend.aws_s3_bucket.tfstate[0]" "$S3_BUCKET" "S3 Bucket: $S3_BUCKET"
fi

# DynamoDB Table
DYNAMODB_TABLE="${PROJECT_NAME}-${ENVIRONMENT}-tfstate-lock"
if resource_exists "aws dynamodb describe-table --table-name $DYNAMODB_TABLE --region $AWS_REGION"; then
    safe_import "module.backend.aws_dynamodb_table.tfstate_lock[0]" "$DYNAMODB_TABLE" "DynamoDB: $DYNAMODB_TABLE"
fi

# ============================================================================
# 2. CONTAINER REGISTRY (ECR)
# ============================================================================
echo ""
echo -e "${BLUE}📦 Container Registry Resources${NC}"

# ECR Repository
ECR_REPO="${PROJECT_NAME}-${ENVIRONMENT}-app"
if resource_exists "aws ecr describe-repositories --repository-names $ECR_REPO --region $AWS_REGION"; then
    safe_import "module.container_registry.aws_ecr_repository.main[0]" "$ECR_REPO" "ECR Repository: $ECR_REPO"
fi

# ============================================================================
# 3. ROUTE 53 (DNS)
# ============================================================================
echo ""
echo -e "${BLUE}📦 DNS Resources${NC}"

# Route53 Zone - Détecter automatiquement
DOMAIN_NAME=$(terraform output -raw domain_name 2>/dev/null || echo "")
if [ ! -z "$DOMAIN_NAME" ]; then
    ZONE_ID=$(aws route53 list-hosted-zones-by-name --dns-name "$DOMAIN_NAME" --query "HostedZones[0].Id" --output text 2>/dev/null | cut -d'/' -f3)
    if [ ! -z "$ZONE_ID" ] && [ "$ZONE_ID" != "None" ]; then
        safe_import "aws_route53_zone.main[0]" "$ZONE_ID" "Route53 Zone: $DOMAIN_NAME"
    fi
fi

# ============================================================================
# 4. COMPUTE RESOURCES (ECS, ALB, IAM, etc.)
# ============================================================================
echo ""
echo -e "${BLUE}📦 Compute & Network Resources${NC}"

# VPC - Détecter par tag
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${PROJECT_NAME}-${ENVIRONMENT}-vpc" --query "Vpcs[0].VpcId" --output text --region $AWS_REGION 2>/dev/null)
if [ ! -z "$VPC_ID" ] && [ "$VPC_ID" != "None" ]; then
    safe_import "module.compute.aws_vpc.main[0]" "$VPC_ID" "VPC: $VPC_ID"
fi

# CloudWatch Log Group
LOG_GROUP="/ecs/${PROJECT_NAME}-${ENVIRONMENT}"
if resource_exists "aws logs describe-log-groups --log-group-name-prefix $LOG_GROUP --region $AWS_REGION"; then
    safe_import "module.compute.aws_cloudwatch_log_group.app[0]" "$LOG_GROUP" "CloudWatch Log Group: $LOG_GROUP"
fi

# IAM Role - ECS Task Execution
TASK_ROLE="${PROJECT_NAME}-${ENVIRONMENT}-ecs-task-execution-role"
if resource_exists "aws iam get-role --role-name $TASK_ROLE"; then
    safe_import "module.compute.aws_iam_role.ecs_task_execution_role[0]" "$TASK_ROLE" "IAM Role: $TASK_ROLE"
fi

# ALB - Application Load Balancer
ALB_NAME="${PROJECT_NAME}-${ENVIRONMENT}-alb"
ALB_ARN=$(aws elbv2 describe-load-balancers --names "$ALB_NAME" --query "LoadBalancers[0].LoadBalancerArn" --output text --region $AWS_REGION 2>/dev/null)
if [ ! -z "$ALB_ARN" ] && [ "$ALB_ARN" != "None" ]; then
    safe_import "module.compute.aws_lb.main[0]" "$ALB_ARN" "ALB: $ALB_NAME"
fi

# Target Group
TG_NAME="${PROJECT_NAME}-${ENVIRONMENT}-tg"
TG_ARN=$(aws elbv2 describe-target-groups --names "$TG_NAME" --query "TargetGroups[0].TargetGroupArn" --output text --region $AWS_REGION 2>/dev/null)
if [ ! -z "$TG_ARN" ] && [ "$TG_ARN" != "None" ]; then
    safe_import "module.compute.aws_lb_target_group.app[0]" "$TG_ARN" "Target Group: $TG_NAME"
fi

# ECS Cluster
ECS_CLUSTER="${PROJECT_NAME}-${ENVIRONMENT}-cluster"
if resource_exists "aws ecs describe-clusters --clusters $ECS_CLUSTER --region $AWS_REGION"; then
    safe_import "module.compute.aws_ecs_cluster.main[0]" "$ECS_CLUSTER" "ECS Cluster: $ECS_CLUSTER"
fi

# ECS Service
ECS_SERVICE="${PROJECT_NAME}-${ENVIRONMENT}-service"
if resource_exists "aws ecs describe-services --cluster $ECS_CLUSTER --services $ECS_SERVICE --region $AWS_REGION"; then
    safe_import "module.compute.aws_ecs_service.app[0]" "$ECS_CLUSTER/$ECS_SERVICE" "ECS Service: $ECS_SERVICE"
fi

# Security Groups
SG_NAME="${PROJECT_NAME}-${ENVIRONMENT}-alb-sg"
SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=$SG_NAME" --query "SecurityGroups[0].GroupId" --output text --region $AWS_REGION 2>/dev/null)
if [ ! -z "$SG_ID" ] && [ "$SG_ID" != "None" ]; then
    safe_import "module.compute.aws_security_group.alb[0]" "$SG_ID" "Security Group ALB: $SG_NAME"
fi

# ============================================================================
# RÉSUMÉ
# ============================================================================
echo ""
echo -e "${BLUE}============================================================================${NC}"
echo -e "${GREEN}✅ Import completed!${NC}"
echo -e "${BLUE}============================================================================${NC}"
echo ""
echo -e "${YELLOW}📝 Next steps:${NC}"
echo "   1. Run 'terraform plan' to verify state"
echo "   2. Run 'terraform apply' to sync any changes"
echo ""
echo -e "${GREEN}🎉 Your Terraform state is now synchronized with AWS resources!${NC}"