terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.56"
  }
}

provider "aws" {
  region = var.region
}

# Pre-existing VPC and subnets located via tags...

data "aws_vpc" "selected" {
  tags = {
    environment = var.environment
    resource    = "vpc"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    environment = var.environment
    access      = "public"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    environment = var.environment
    access      = "private"
  }
}

locals {
  tags = merge(
    var.tags,
    map(
      "environment", "${var.environment}"
    )
  )
  vpc             = data.aws_vpc.selected.id
  cidr            = data.aws_vpc.selected.cidr_block
  public_subnets  = data.aws_subnet_ids.public.ids
  private_subnets = data.aws_subnet_ids.private.ids
}
