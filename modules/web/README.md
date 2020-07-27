# Usage

Terraform module that deploys an ALB fronted ECS task.

```hcl
data "aws_caller_identity" "current" {}

locals {
  account_id              = data.aws_caller_identity.current.account_id
  task_role               = length(var.task_role) != 0 ? var.task_role : "arn:aws:iam::${local.account_id}:role/ecsTaskExecutionRole"
  exec_role               = length(var.exec_role) != 0 ? var.exec_role : "arn:aws:iam::${local.account_id}:role/ecsTaskExecutionRole"
  deployment_subnets      = module.network.subnet_ids
  deployment_subnet_cidrs = module.network.subnet_cidrs
  vpc_id                  = module.network.vpc_id
}

module "web" {
  source                  = "../../modules/web"
  app_name                = var.app_name
  container_cpu           = var.container_cpu
  container_memory        = var.container_memory
  container_port          = var.container_port
  deployment_subnets      = local.deployment_subnets
  deployment_subnet_cidrs = local.deployment_subnet_cidrs
  ecr_expire_days         = var.ecr_expire_days
  environment             = var.environment
  exec_role               = local.exec_role
  instance_count          = var.instance_count
  deployment_percent_max  = var.deployment_percent_max
  deployment_percent_min  = var.deployment_percent_min
  region                  = var.region
  tags                    = var.tags
  task_role               = local.task_role
  vpc_id                  = local.vpc_id
  web_log_retention_days  = var.web_log_retention_days
}
```

## Testing

We use [Terratest](https://terratest.gruntwork.io). You need to have Go installed and configured.

```console
$ cd test
$ make test
```

## Inputs

| Name                    | Description                                  |  Type  | Default                                                                                       | Required |
| ----------------------- | -------------------------------------------- | :----: | --------------------------------------------------------------------------------------------- | :------: |
| app_name                | Descriptive name used to build IDs           | string | `` | yes                                                                                      |
| container_cpu           | CPU units for ECS task (1024 = 1 vCPU)       | number | `` | yes                                                                                      |
| container_memory        | Memory for ECS task (MB)                     | number | `` | yes                                                                                      |
| container_port          | Port exposed by application container        | number | `8080`                                                                                        |   yes    |
| deployment_percent_max  | Maximum %healthy containers                  | number | `` | no                                                                                       |
| deployment_percent_min  | Minimum %healthy containers                  | number | `` | no                                                                                       |
| deployment_subnets      | Deployment subnets used by ECS task          |  list  | `` | yes                                                                                      |
| deployment_subnet_cidrs | Deployment subnet CIDR blocks                |  list  | `` | yes                                                                                      |
| ecr_expire_days         | Days before purging untagged images from ECR | number | `1`                                                                                           |   yes    |
| environment             | Name of target environment                   | string | `` | yes                                                                                      |
| exec_role               | Role used by ECS service                     | string | `ecsTaskExecutionRole`                                                                        |    no    |
| instance_count          | Number of ECS tasks to launch                | number | `` | no                                                                                       |
| region                  | Region to target for deployment              | string | `us-east-2`                                                                                   |    no    |
| tags                    | Custom tags to apply to resources            |  map   | <pre>{<br/> description = "experimenting with terratest"<br/> owner = "test corp"<br/>}</pre> |    no    |
| task_role               | Role used by ECS tasks                       | string | `ecsTaskExecutionRole`                                                                        |    no    |
| vpc_id                  | VPC ID used for deployment                   | number | `` | no                                                                                       |
| web_log_retention_days  | Days before puring CloudWatch app logs       | number | `1`                                                                                           |    no    |

## Outputs

| Name                 | Description                           |
| -------------------- | ------------------------------------- |
| availability_zones   | List of available AZs in region       |
| cloudwatch_log_group | CloudWatch log group housing app logs |
| dns_name             | External DNS name of ALB              |
| ecr_repository_url   | URL of ECR repository                 |
| subnet_cidrs         | List of subnet CIDR ranges in VPC     |
| subnet_ids           | List of subnet IDs in VPC             |
| vpc_cidr             | VPC CIDR range for environment        |
| vpc_id               | VPC ID for environment                |
