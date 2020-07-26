terraform {
  required_version = "~> 0.12.0"

  required_providers {
    aws = "~> 2.42"
  }
}

provider "aws" {
  region = var.region
}

