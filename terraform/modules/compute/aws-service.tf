# ============================================================================
# PARTIE 6 : ECS SERVICE - AWS
# ============================================================================

# ----------------------------------------------------------------------------
# RESOURCE: ECS Service
# ----------------------------------------------------------------------------
# Service qui maintient le nombre d'instances désiré
resource "aws_ecs_service" "app" {
  count = var.cloud_provider == "aws" ? 1 : 0

  name            = "${var.project_name}-${var.environment}-${var.app_name}"
  cluster         = aws_ecs_cluster.main[0].id
  task_definition = aws_ecs_task_definition.app[0].arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  # Configuration réseau pour Fargate
  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks[0].id]
    subnets          = aws_subnet.private[*].id
    assign_public_ip = false  # Privé, accès via NAT Gateway
  }

  # Intégration avec le Load Balancer
  load_balancer {
    target_group_arn = aws_lb_target_group.app[0].arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  # Stratégie de déploiement par défaut (rolling update)

  # Attendre que le load balancer soit prêt
  depends_on = [
    aws_lb_listener.http,
    aws_iam_role_policy_attachment.ecs_task_execution_role
  ]

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-service"
      Type = "ECSService"
    }
  )
}

# ============================================================================
# PARTIE 7 : AUTO SCALING (OPTIONNEL) - AWS
# ============================================================================

# ----------------------------------------------------------------------------
# RESOURCE: Auto Scaling Target
# ----------------------------------------------------------------------------
resource "aws_appautoscaling_target" "ecs_target" {
  count = var.cloud_provider == "aws" && var.enable_autoscaling ? 1 : 0

  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.main[0].name}/${aws_ecs_service.app[0].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# ----------------------------------------------------------------------------
# RESOURCE: Auto Scaling Policy (CPU)
# ----------------------------------------------------------------------------
resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  count = var.cloud_provider == "aws" && var.enable_autoscaling ? 1 : 0

  name               = "${var.project_name}-${var.environment}-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0  # Scale up si CPU > 70%
  }
}

# ----------------------------------------------------------------------------
# RESOURCE: Auto Scaling Policy (Memory)
# ----------------------------------------------------------------------------
resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  count = var.cloud_provider == "aws" && var.enable_autoscaling ? 1 : 0

  name               = "${var.project_name}-${var.environment}-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80.0  # Scale up si Memory > 80%
  }
}