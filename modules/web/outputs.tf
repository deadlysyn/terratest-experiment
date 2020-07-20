output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.web.name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.web.repository_url
}

output "dns_name" {
  value = aws_lb.web.dns_name
}
