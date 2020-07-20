app_name               = "terratest-experiment"
container_cpu          = 256
container_memory       = 512
container_port         = 8080
environment            = "dev"
instance_count         = 1
deployment_percent_max = 100
deployment_percent_min = 0
region                 = "us-east-2"

# Use default VPC to run easily in most accounts
vpc_filters = [{
  name   = "isDefault"
  values = [true]
}]

# If not specified, default to ecsTaskExecutionRole
#exec_role = "arn:aws:iam::${account_id}:role/ecsTaskExecutionRole"
#task_role = "arn:aws:iam::${account_id}:role/ecsTaskExecutionRole"

# Defaults minimize cruft
#ecr_expire_days        = 1
#web_log_retention_days = 1
