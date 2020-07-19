output "availability_zones" {
  value = module.network.availability_zones
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

output "ecr_repository_url" {
  value = module.web_task.ecr_repository_url
}
