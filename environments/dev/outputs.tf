output "availability_zones" {
  value = module.network.availability_zones
}

output "cloudwatch_log_group" {
  value = module.web.cloudwatch_log_group
}

output "dns_name" {
  value = module.web.dns_name
}

output "ecr_repository_url" {
  value = module.web.ecr_repository_url
}

output "subnet_cidrs" {
  value = module.network.subnet_cidrs
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

output "vpc_cidr" {
  value = module.network.vpc_cidr
}

output "vpc_id" {
  value = module.network.vpc_id
}
