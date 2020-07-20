variable "app_name" {
  description = "App/ECS task family name"
  type        = string
}

variable "container_cpu" {
  description = "CPU units used by task (1024 = 1 CPU)"
  type        = number
}

variable "container_memory" {
  description = "Memory used by task in MiB"
  type        = number
}

variable "ecr_expire_days" {
  description = "How many days to keep old ECR images"
  type        = number
}

variable "environment" {
  description = "Environment to deploy"
  type        = string
}

variable "exec_role" {
  description = "IAM role used by Fargate to make API calls"
  type        = string
}

variable "region" {
  description = "AWS region to target"
  type        = string
}

variable "instance_count" {
  description = "Number of task instances"
  type        = number
}

variable "deployment_percent_max" {
  description = "Maximum allowed task percentage (supports rolling deployments)"
  type        = number
}

variable "deployment_percent_min" {
  description = "Minimum allowed task percentage (supports rolling deployments)"
  type        = number
}

variable "deployment_subnets" {
  description = "Subnets IDs used for task deployment"
  type        = list(string)
}

variable "deployment_subnet_cidrs" {
  description = "Subnets CIDRs used for task deployment"
  type        = list(string)
}

variable "container_port" {
  description = "Port exposed by app container"
  type        = number
}

variable "tags" {
  description = "Standard tags for all resources"
  type        = map
}

variable "task_role" {
  description = "IAM role granting Fargate task permissions"
  type        = string
}

variable "vpc_id" {
  description = "ID of VPC for deployment"
  type        = string
}

variable "web_log_retention_days" {
  description = "How long to keep web app cloudwatch logs"
  type        = number
}
