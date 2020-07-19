variable "region" {
  description = "AWS region to target"
  type        = string
}

variable "vpc_filter" {
  description = "Filter used to select VPC"
  type = object({
    name   = string,
    values = list(any)
  })
}
