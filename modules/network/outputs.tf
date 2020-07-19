output "availability_zones" {
  value = data.aws_availability_zones.available.names
}

output "subnet_cidrs" {
  value = [for s in data.aws_subnet.selected : s.cidr_block]
}

output "subnet_ids" {
  value = data.aws_subnet_ids.selected.ids
}

output "vpc_cidr" {
  value = data.aws_vpc.selected.cidr_block
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}
