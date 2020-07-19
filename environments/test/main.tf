terraform {
  required_version = "~> 0.12.0"

  required_providers {
    aws = "~> 2.42"
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  # account_arn = data.aws_caller_identity.current.arn
  task_role = length(var.task_role) != 0 ? var.task_role : "arn:aws:iam::${local.account_id}:role/ecsTaskExecutionRole"
  exec_role = length(var.exec_role) != 0 ? var.exec_role : "arn:aws:iam::${local.account_id}:role/ecsTaskExecutionRole"
}

module "network" {
  source      = "../../modules/network"
  region      = var.region
  vpc_filters = var.vpc_filters
}

module "web_task" {
  source                 = "../../modules/web-task"
  app_name               = var.app_name
  container_cpu          = var.container_cpu
  container_memory       = var.container_memory
  ecr_expire_days        = var.ecr_expire_days
  environment            = var.environment
  exec_role              = var.exec_role
  region                 = var.region
  tags                   = var.tags
  task_role              = var.task_role
  web_log_retention_days = var.web_log_retention_days
}
