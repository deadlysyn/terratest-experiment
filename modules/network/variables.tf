variable "region" {
  description = "AWS region to target"
  type        = string
}

variable "vpc_filters" {
  description = "Filters used to select VPC"
  type = list(object({
    name   = string,
    values = list(any)
  }))
}
