output "vpc_id" {
  value = module.web.vpc_id
}

output "subnet_ids" {
  value = module.web.subnet_ids
}

output "ecr_repository_url" {
  value = module.web.ecr_repository_url
}
