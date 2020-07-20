provider "aws" {
  region = var.region
}

locals {
  tags = merge(
    var.tags,
    map(
      "environment", "${var.environment}"
    )
  )
}

resource "aws_ecr_repository" "web" {
  name                 = "${var.app_name}-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

resource "aws_ecr_lifecycle_policy" "web" {
  repository = aws_ecr_repository.web.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire untagged images older than a week",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${var.ecr_expire_days}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_log_group" "web" {
  name              = "/ecs/${var.app_name}-${var.environment}"
  retention_in_days = var.web_log_retention_days
  tags              = local.tags
}

resource "aws_ecs_cluster" "web" {
  name = "${var.app_name}-${var.environment}"

  tags = local.tags

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "web" {
  family = "${var.app_name}-${var.environment}"
  container_definitions = templatefile("${path.module}/templates/containerDefinition.json", {
    container_cpu    = var.container_cpu,
    container_memory = var.container_memory,
    environment      = var.environment,
    image            = "${aws_ecr_repository.web.repository_url}:latest"
    name             = "${var.app_name}-${var.environment}",
    region           = var.region
  })
  task_role_arn      = var.task_role
  execution_role_arn = var.exec_role
  network_mode       = "awsvpc"
  cpu                = var.container_cpu
  memory             = var.container_memory

  depends_on = [aws_cloudwatch_log_group.web]

  tags = local.tags
}

resource "aws_security_group" "web_task" {
  name        = "${var.app_name}-${var.environment}-web-tasks"
  description = "Allow web task traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = var.deployment_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_ecs_service" "web" {
  name                    = "${var.app_name}-${var.environment}"
  cluster                 = aws_ecs_cluster.web.arn
  task_definition         = aws_ecs_task_definition.web.arn
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"
  launch_type             = "FARGATE"
  scheduling_strategy     = "REPLICA"

  desired_count                      = var.instance_count
  deployment_minimum_healthy_percent = var.deployment_percent_min
  deployment_maximum_percent         = var.deployment_percent_max

  network_configuration {
    subnets         = var.deployment_subnets
    security_groups = [aws_security_group.web_task.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "${var.app_name}-${var.environment}-app"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = local.tags
}

resource "aws_security_group" "web_alb" {
  name        = "${var.app_name}-${var.environment}-web-alb"
  description = "Allow traffic from Internet to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_lb" "web" {
  name               = "${var.app_name}-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_alb.id]
  subnets            = var.deployment_subnets

  tags = local.tags
}

resource "aws_lb_target_group" "web" {
  name                          = "${var.app_name}-${var.environment}"
  port                          = var.container_port
  protocol                      = "HTTP"
  vpc_id                        = var.vpc_id
  load_balancing_algorithm_type = "least_outstanding_requests"
  target_type                   = "ip"
  deregistration_delay          = 10

  health_check {
    interval = 60
    path     = "/"
    matcher  = "200"
  }

  depends_on = [aws_lb.web]

  tags = local.tags
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
