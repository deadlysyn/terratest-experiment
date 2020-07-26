app_name               = "terratest-experiment"
container_cpu          = 256
container_memory       = 512
container_port         = 8080
environment            = "dev"
deployment_percent_max = 100
deployment_percent_min = 50
instance_count         = 2
region                 = "us-east-2"

# Default VPC to run most places easily
# vpc_filters = [{
#  name   = "isDefault"
#  values = [true]
# }]

# Default to ecsTaskExecutionRole if not specified
#exec_role = "arn:aws:iam::${account_id}:role/ecsTaskExecutionRole"
#task_role = "arn:aws:iam::${account_id}:role/ecsTaskExecutionRole"

# Defaults minimize cruft
#ecr_expire_days        = 1
#web_log_retention_days = 1

