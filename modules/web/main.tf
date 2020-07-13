terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.56"
  }
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "selected" {
  filter {
    name   = "isDefault"
    values = [true]
  }
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_vpc.selected.id
}

locals {
  tags = merge(
    var.tags,
    map(
      "environment", "${var.environment}"
    )
  )
  vpc     = data.aws_vpc.selected.id
  cidr    = data.aws_vpc.selected.cidr_block
  subnets = data.aws_subnet_ids.selected.ids
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

resource "aws_ecs_cluster" "user_provisioning" {
  name = "${var.app_name}-${var.environment}"

  tags = local.tags

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# resource "aws_ecs_task_definition" "user_provisioning" {
#   family = "${var.app_name}-${var.environment}"
#   container_definitions = templatefile("containerDefinition.json", {
#     name        = "${var.app_name}-${var.environment}",
#     environment = var.environment,
#     image       = "${aws_ecr_repository.user_provisioning.repository_url}:latest"
#     region      = var.region
#   })
#   task_role_arn      = "arn:aws:iam::488733969274:role/ecsTaskExecutionRole"
#   execution_role_arn = "arn:aws:iam::488733969274:role/ecsTaskExecutionRole"
#   network_mode       = "awsvpc"
#   cpu                = "256"
#   memory             = "512"

#   depends_on = [aws_cloudwatch_log_group.user_provisioning]

#   tags = local.tags
# }

# resource "aws_ecs_service" "user_provisioning" {
#   name                              = "${var.app_name}-${var.environment}"
#   cluster                           = aws_ecs_cluster.user_provisioning.arn
#   task_definition                   = aws_ecs_task_definition.user_provisioning.arn
#   enable_ecs_managed_tags           = true
#   propagate_tags                    = "SERVICE"
#   health_check_grace_period_seconds = 10
#   launch_type                       = "FARGATE"
#   scheduling_strategy               = "REPLICA"

#   desired_count                      = var.instance_count
#   deployment_maximum_percent         = var.instance_percent_max
#   deployment_minimum_healthy_percent = var.instance_percent_min

#   network_configuration {
#     subnets         = local.private_subnets
#     security_groups = [aws_security_group.instance.id]
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.user_provisioning.arn
#     container_name   = "${var.app_name}-${var.environment}-app"
#     container_port   = var.container_port
#   }

#   lifecycle {
#     ignore_changes = [desired_count]
#   }

#   tags = local.tags
# }
