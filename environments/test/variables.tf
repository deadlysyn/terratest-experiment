variable "region" {
  description = "AWS region to target"
  type        = string
}

variable "environment" {
  description = "Environment to deploy"
  type        = string
}

# variable "app_name" {
#   description = "App/ECS task family name"
#   type        = string
#   default     = "user-provisioning"
# }

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
