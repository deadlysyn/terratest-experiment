# Usage

Purposefully simple module that enumerates network details in specified
AWS region based on provided filter.

```hcl
module "network" {
  source     = "./network"
  region     = var.region
  vpc_filter = var.vpc_filter
}
```

## Testing

We use [Terratest](https://terratest.gruntwork.io). You need to have Go installed and configured.

```console
$ cd test
$ make test
```

## Inputs

| Name       | Description                       |                                     Type                                      | Default                                                         | Required |
| ---------- | --------------------------------- | :---------------------------------------------------------------------------: | --------------------------------------------------------------- | :------: |
| region     | AWS region to target              |                                    string                                     | `` | yes                                                        |
| vpc_filter | AWS API filter used to select VPC | <pre>list(object({<br/> name = "string"<br/> values = list(any)<br/>}))</pre> | <pre>[{<br/>name = "isDefault"<br/>values = [true]<br/>}]</pre> |   yes    |

## Outputs

| Name               | Description                       |
| ------------------ | --------------------------------- |
| availability_zones | List of available AZs in region   |
| subnet_cidrs       | List of subnet CIDR ranges in VPC |
| subnet_ids         | List of subnet IDs in VPC         |
| vpc_cidr           | VPC CIDR range for environment    |
| vpc_id             | VPC ID for environment            |
