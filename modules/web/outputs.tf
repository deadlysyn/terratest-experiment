output "vpc_id" {
  value = data.aws_vpc.selected.id
}

output "subnet_ids" {
  value = data.aws_subnet_ids.selected.ids
}
