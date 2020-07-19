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
  default     = 1
}

variable "environment" {
  description = "Environment to deploy"
  type        = string
}

variable "exec_role" {
  description = "IAM role used by Fargate to make API calls"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region to target"
  type        = string
  default     = "us-east-2"
}


# variable "instance_count" {
#   description = "Number of task instances"
#   type        = number
# }

# variable "instance_percent_max" {
#   description = "Maximum allowed task percentage (supports rolling deployments)"
#   type        = number
# }

# variable "instance_percent_min" {
#   description = "Minimum allowed task percentage (supports rolling deployments)"
#   type        = number
# }

# variable "container_port" {
#   description = "Port exposed by app container"
#   type        = number
#   default     = 8080
# }

variable "tags" {
  description = "Standard tags for all resources"
  type        = map
  default = {
    description = "experimenting with terratest"
    owner       = "test corp"
  }
}

variable "task_role" {
  description = "IAM role granting Fargate task permissions"
  type        = string
  default     = ""
}

variable "vpc_filters" {
  description = "Filters used to select VPC"
  type = list(object({
    name   = string,
    values = list(any)
  }))
}

variable "web_log_retention_days" {
  description = "How long to keep web app cloudwatch logs"
  type        = number
  default     = 1
}
