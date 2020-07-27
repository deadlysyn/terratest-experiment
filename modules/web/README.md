# Usage

Terraform module that deploys an ALB fronted ECS task.

```hcl
module "network" {
  source     = "./web-task"
  region     = var.region
  vpc_filter = var.vpc_filter
}
```

## Testing

We use [Terratest](https://terratest.gruntwork.io). You need to have Go installed and configured.

```console
$ cd test
$ make test
```

## Inputs

| Name                    | Description                                  |  Type  |                                            Default                                            | Required |
| ----------------------- | -------------------------------------------- | :----: | :-------------------------------------------------------------------------------------------: | :------: |
| app_name                | Descriptive name used to build IDs           | string |                                           `` | yes                                            |
| container_cpu           | CPU slices for ECS task (1024 = 1 vCPU)      | number |                                           `` | yes                                            |
| container_memory        | Memory for ECS task (MB)                     | number |                                           `` | yes                                            |
| container_port          | Port exposed by application container        | number |                                            `8080`                                             |   yes    |
| deployment_percent_max  | Maximum %healthy containers                  | number |                                            `` | no                                            |
| deployment_percent_min  | Minimum %healthy containers                  | number |                                            `` | no                                            |
| deployment_subnets      | Deployment subnets used by ECS task          |  list  |                                           `` | yes                                            |
| deployment_subnet_cidrs | Deployment subnet CIDR blocks                |  list  |                                           `` | yes                                            |
| ecr_expire_days         | Days before purging untagged images from ECR | number |                                              `1`                                              |   yes    |
| environment             | Name of target environment                   | string |                                           `` | yes                                            |
| exec_role               | Role used by ECS service                     | string |                                    `ecsTaskExecutionRole`                                     |    no    |
| instance_count          | Number of ECS tasks to launch                | number |                                            `` | no                                            |
| region                  | Region to target for deployment              | string |                                          `us-east-2`                                          |    no    |
| tags                    | Custom tags to apply to resources            |  map   | <pre>{<br/> description = "experimenting with terratest"<br/> owner = "test corp"<br/>}</pre> |    no    |
| task_role               | Role used by ECS tasks                       | string |                                    `ecsTaskExecutionRole`                                     |    no    |
| vpc_id                  | VPC ID used for deployment                   | number |                                            `` | no                                            |
| web_log_retention_days  | Days before puring CloudWatch app logs       | number |                                              `1`                                              |    no    |

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
