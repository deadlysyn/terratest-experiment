terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.56"
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

module "web" {
  source                 = "../../modules/web"
  app_name               = var.app_name
  ecr_expire_days        = var.ecr_expire_days
  environment            = var.environment
  region                 = var.region
  tags                   = var.tags
  web_log_retention_days = var.web_log_retention_days
  # alb_destroy_log_bucket             = var.alb_destroy_log_bucket
  # aws_account_id                     = data.aws_caller_identity.current.account_id
  # aws_account_arn                    = data.aws_caller_identity.current.arn
}

