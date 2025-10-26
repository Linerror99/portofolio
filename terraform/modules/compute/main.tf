# ============================================================================
# MODULE: Compute - Main Configuration
# ============================================================================
# Ce module déploie l'application React en production avec un domaine propre

# ============================================================================
# PARTIE 1 : INFRASTRUCTURE RÉSEAU AWS
# ============================================================================

# ----------------------------------------------------------------------------
# LOCAL: Zones de disponibilité pour us-west-1
# ----------------------------------------------------------------------------
locals {
  availability_zones = var.cloud_provider == "aws" ? ["us-west-1a", "us-west-1c"] : []
}

# ----------------------------------------------------------------------------
# RESOURCE: VPC (Virtual Private Cloud)
# ----------------------------------------------------------------------------
# Créé un réseau privé pour l'application
resource "aws_vpc" "main" {
  count = var.cloud_provider == "aws" ? 1 : 0

  cidr_block           = "10.0.0.0/16"  # 65,536 IPs disponibles
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc"
      Type = "VPC"
    }
  )
}

# ----------------------------------------------------------------------------
# RESOURCE: Internet Gateway
# ----------------------------------------------------------------------------
# Permet l'accès Internet depuis le VPC
resource "aws_internet_gateway" "main" {
  count = var.cloud_provider == "aws" ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-igw"
      Type = "InternetGateway"
    }
  )
}

# ----------------------------------------------------------------------------
# RESOURCE: Subnets Publics
# ----------------------------------------------------------------------------
# Subnets où seront placés les load balancers (accès Internet)
resource "aws_subnet" "public" {
  count = var.cloud_provider == "aws" ? length(local.availability_zones) : 0

  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = "10.0.${count.index + 1}.0/24"  # 10.0.1.0/24, 10.0.2.0/24
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-public-${count.index + 1}"
      Type = "PublicSubnet"
    }
  )
}

# ----------------------------------------------------------------------------
# RESOURCE: Subnets Privés
# ----------------------------------------------------------------------------
# Subnets où seront placés les conteneurs (pas d'accès Internet direct)
resource "aws_subnet" "private" {
  count = var.cloud_provider == "aws" ? length(local.availability_zones) : 0

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = "10.0.${count.index + 10}.0/24"  # 10.0.10.0/24, 10.0.11.0/24
  availability_zone = local.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-private-${count.index + 1}"
      Type = "PrivateSubnet"
    }
  )
}

# ----------------------------------------------------------------------------
# RESOURCE: NAT Gateway
# ----------------------------------------------------------------------------
# Permet aux conteneurs privés d'accéder à Internet (pour pull images)
resource "aws_eip" "nat" {
  count = var.cloud_provider == "aws" ? 1 : 0

  domain = "vpc"
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-nat-eip"
      Type = "NATGatewayEIP"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  count = var.cloud_provider == "aws" ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-nat"
      Type = "NATGateway"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

# ----------------------------------------------------------------------------
# RESOURCE: Route Tables
# ----------------------------------------------------------------------------
# Table de routage pour les subnets publics (vers Internet Gateway)
resource "aws_route_table" "public" {
  count = var.cloud_provider == "aws" ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-public-rt"
      Type = "PublicRouteTable"
    }
  )
}

# Association subnets publics → route table public
resource "aws_route_table_association" "public" {
  count = var.cloud_provider == "aws" ? 2 : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# Table de routage pour les subnets privés (vers NAT Gateway)
resource "aws_route_table" "private" {
  count = var.cloud_provider == "aws" ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[0].id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-private-rt"
      Type = "PrivateRouteTable"
    }
  )
}

# Association subnets privés → route table privé
resource "aws_route_table_association" "private" {
  count = var.cloud_provider == "aws" ? 2 : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}

# ============================================================================
# PARTIE 2 : SÉCURITÉ AWS (Security Groups)
# ============================================================================

# ----------------------------------------------------------------------------
# RESOURCE: Security Group pour ALB (Load Balancer)
# ----------------------------------------------------------------------------
resource "aws_security_group" "alb" {
  count = var.cloud_provider == "aws" ? 1 : 0

  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group pour Application Load Balancer"
  vpc_id      = aws_vpc.main[0].id

  # Ingress: Accepte HTTP depuis n'importe où
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Internet entier
  }

  # Ingress: Accepte HTTPS depuis n'importe où
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Internet entier
  }

  # Egress: Peut envoyer vers n'importe où (pour health checks)
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-alb-sg"
      Type = "ALBSecurityGroup"
    }
  )
}

# ----------------------------------------------------------------------------
# RESOURCE: Security Group pour ECS Tasks
# ----------------------------------------------------------------------------
resource "aws_security_group" "ecs_tasks" {
  count = var.cloud_provider == "aws" ? 1 : 0

  name        = "${var.project_name}-${var.environment}-ecs-tasks-sg"
  description = "Security group pour ECS tasks"
  vpc_id      = aws_vpc.main[0].id

  # Ingress: Accepte le trafic depuis ALB uniquement
  ingress {
    description     = "HTTP from ALB"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb[0].id]
  }

  # Egress: Peut envoyer vers Internet (pour pull images, API calls)
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-ecs-tasks-sg"
      Type = "ECSTasksSecurityGroup"
    }
  )
}