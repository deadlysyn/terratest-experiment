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

resource "aws_ecr_repository" "web_task" {
  name                 = "${var.app_name}-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

resource "aws_ecr_lifecycle_policy" "web_task" {
  repository = aws_ecr_repository.web_task.name

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

resource "aws_cloudwatch_log_group" "web_task" {
  name              = "/ecs/${var.app_name}-${var.environment}"
  retention_in_days = var.web_log_retention_days
  tags              = local.tags
}

resource "aws_ecs_cluster" "web_task" {
  name = "${var.app_name}-${var.environment}"

  tags = local.tags

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "web_task" {
  family = "${var.app_name}-${var.environment}"
  container_definitions = templatefile("${path.module}/templates/containerDefinition.json", {
    container_cpu    = var.container_cpu,
    container_memory = var.container_memory,
    environment      = var.environment,
    image            = "${aws_ecr_repository.web_task.repository_url}:latest"
    name             = "${var.app_name}-${var.environment}",
    region           = var.region
  })
  task_role_arn      = var.task_role
  execution_role_arn = var.exec_role
  network_mode       = "awsvpc"
  cpu                = var.container_cpu
  memory             = var.container_memory

  depends_on = [aws_cloudwatch_log_group.web_task]

  tags = local.tags
}

resource "aws_security_group" "web_task" {
  name        = "allow_web_task_traffic"
  description = "Ingress and egress for web task"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
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

resource "aws_ecs_service" "web_task" {
  name                    = "${var.app_name}-${var.environment}"
  cluster                 = aws_ecs_cluster.web_task.arn
  task_definition         = aws_ecs_task_definition.web_task.arn
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"
  launch_type             = "FARGATE"
  scheduling_strategy     = "REPLICA"

  desired_count                      = var.instance_count
  deployment_minimum_healthy_percent = var.deployment_percent_min
  deployment_maximum_percent         = var.deployment_percent_max

  network_configuration {
    assign_public_ip = true
    subnets          = var.deployment_subnets
    security_groups  = [aws_security_group.web_task.id]
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = local.tags
}
