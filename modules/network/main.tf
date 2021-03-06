provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

data "aws_vpc" "selected" {
  dynamic "filter" {
    for_each = var.vpc_filters
    content {
      name   = filter.value["name"]
      values = filter.value["values"]
    }
  }
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_vpc.selected.id
}

data "aws_subnet" "selected" {
  for_each = data.aws_subnet_ids.selected.ids
  id       = each.value
}
