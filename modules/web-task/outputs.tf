output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.web_task.name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.web_task.repository_url
}
