# ============================================================================
# PARTIE 3 : ECS (Elastic Container Service) - AWS
# ============================================================================



# ----------------------------------------------------------------------------
# RESOURCE: ECS Cluster
# ----------------------------------------------------------------------------
# Cluster logique qui va héberger nos services
resource "aws_ecs_cluster" "main" {
  count = var.cloud_provider == "aws" ? 1 : 0

  name = "${var.project_name}-${var.environment}"

  # Configuration Fargate (serverless)
  setting {
    name  = "containerInsights"
    value = "enabled"  # Monitoring des conteneurs
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-cluster"
      Type = "ECSCluster"
    }
  )
}

# ----------------------------------------------------------------------------
# RESOURCE: CloudWatch Log Group
# ----------------------------------------------------------------------------
# Centralise les logs de l'application
resource "aws_cloudwatch_log_group" "app" {
  count = var.cloud_provider == "aws" ? 1 : 0

  name              = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = 7  # Garde les logs 7 jours (suffisant pour portfolio)

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-logs"
      Type = "LogGroup"
    }
  )
}

# ----------------------------------------------------------------------------
# RESOURCE: ECS Task Definition
# ----------------------------------------------------------------------------
# Définit le conteneur : image, CPU, mémoire, ports, logs
resource "aws_ecs_task_definition" "app" {
  count = var.cloud_provider == "aws" ? 1 : 0

  family                   = "${var.project_name}-${var.environment}-${var.app_name}"
  network_mode             = "awsvpc"       # Chaque task a sa propre IP
  requires_compatibilities = ["FARGATE"]    # Serverless
  cpu                      = var.cpu        # 256 = 0.25 vCPU
  memory                   = var.memory     # 512 MB
  execution_role_arn       = aws_iam_role.ecs_task_execution_role[0].arn

  container_definitions = jsonencode([
    {
      name  = var.app_name
      image = var.container_image
      
      # Configuration réseau
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      # Health check
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port}${var.health_check_path} || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      # Logs
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app[0].name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }

      # Variables d'environnement
      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "PORT"
          value = tostring(var.container_port)
        }
      ]

      # Obligatoire pour Fargate
      essential = true
    }
  ])

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-task-definition"
      Type = "ECSTaskDefinition"
    }
  )
}

# ----------------------------------------------------------------------------
# RESOURCE: IAM Role pour ECS Task Execution
# ----------------------------------------------------------------------------
# Permet à ECS de pull l'image et écrire les logs
resource "aws_iam_role" "ecs_task_execution_role" {
  count = var.cloud_provider == "aws" ? 1 : 0

  name = "${var.project_name}-${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-ecs-execution-role"
      Type = "IAMRole"
    }
  )
}

# Attacher la policy AWS managed
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  count = var.cloud_provider == "aws" ? 1 : 0

  role       = aws_iam_role.ecs_task_execution_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ============================================================================
# PARTIE 4 : APPLICATION LOAD BALANCER (ALB) - AWS
# ============================================================================

# ----------------------------------------------------------------------------
# RESOURCE: Application Load Balancer
# ----------------------------------------------------------------------------
resource "aws_lb" "main" {
  count = var.cloud_provider == "aws" ? 1 : 0

  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false  # Public (accessible depuis Internet)
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb[0].id]
  subnets            = aws_subnet.public[*].id

  # Suppression protection (désactivée pour faciliter les tests)
  enable_deletion_protection = false

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-alb"
      Type = "ApplicationLoadBalancer"
    }
  )
}

# ----------------------------------------------------------------------------
# RESOURCE: Target Group
# ----------------------------------------------------------------------------
# Groupe de cibles (nos conteneurs ECS)
resource "aws_lb_target_group" "app" {
  count = var.cloud_provider == "aws" ? 1 : 0

  name        = "${var.project_name}-${var.environment}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main[0].id
  target_type = "ip"  # Pour Fargate

  # Health check configuration
  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-tg"
      Type = "TargetGroup"
    }
  )
}

# ----------------------------------------------------------------------------
# RESOURCE: ALB Listener HTTP 
# ----------------------------------------------------------------------------
resource "aws_lb_listener" "http" {
  count = var.cloud_provider == "aws" ? 1 : 0

  load_balancer_arn = aws_lb.main[0].arn
  port              = "80"
  protocol          = "HTTP"

  # Si HTTPS activé, redirect, sinon forward directement
  default_action {
    type = var.create_certificate ? "redirect" : "forward"
    
    # Redirect vers HTTPS (seulement si certificat activé)
    dynamic "redirect" {
      for_each = var.create_certificate ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    
    # Forward vers target group (si pas de certificat)
    target_group_arn = var.create_certificate ? null : aws_lb_target_group.app[0].arn
  }
}

# ----------------------------------------------------------------------------
# RESOURCE: ALB Listener HTTPS (si certificat activé)
# ----------------------------------------------------------------------------
resource "aws_lb_listener" "https" {
  count = var.cloud_provider == "aws" && var.create_certificate ? 1 : 0

  load_balancer_arn = aws_lb.main[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.domain_name != "" ? aws_acm_certificate_validation.main[0].certificate_arn : aws_acm_certificate.default[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[0].arn
  }
}

# ============================================================================
# PARTIE 5 : CERTIFICATS SSL/TLS - AWS
# ============================================================================

# ----------------------------------------------------------------------------
# RESOURCE: Certificat SSL pour domaine custom
# ----------------------------------------------------------------------------
resource "aws_acm_certificate" "main" {
  count = var.cloud_provider == "aws" && var.create_certificate && var.domain_name != "" ? 1 : 0

  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-cert"
      Type = "SSLCertificate"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------------------------------------------------------------
# RESOURCE: Validation DNS du certificat SSL
# ----------------------------------------------------------------------------
resource "aws_route53_record" "cert_validation" {
  for_each = var.cloud_provider == "aws" && var.create_certificate && var.domain_name != "" ? {
    for dvo in aws_acm_certificate.main[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

resource "aws_acm_certificate_validation" "main" {
  count = var.cloud_provider == "aws" && var.create_certificate && var.domain_name != "" ? 1 : 0

  certificate_arn         = aws_acm_certificate.main[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

  timeouts {
    create = "5m"
  }
}

# ----------------------------------------------------------------------------
# RESOURCE: Certificat SSL auto-signé (fallback)
# ----------------------------------------------------------------------------
resource "aws_acm_certificate" "default" {
  count = var.cloud_provider == "aws" && var.enable_https && var.domain_name == "" ? 1 : 0

  domain_name       = "${var.project_name}-${var.environment}.example.com"
  validation_method = "DNS"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-default-cert"
      Type = "DefaultSSLCertificate"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}