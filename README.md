# VPC Module

AWS VPC module to create a basic VPCs with 1 public subnet in AWS.

## How To Use

### Variables
* `name_prefix`: String (optional, default: `tf-`)
* `cidr_block`: String (optional, default: `172.31.0.0/16`)

### Outputs
* `vpc_id`: String 
* `subnet_id`: String
* `default_security_group`: String

### Example
```hcl
module "vpc" {
  source = "github.com/gbergere/tf-vpc-module"
}
```

## Used by
* [tf-consul-module](https://github.com/gbergere/tf-consul-module)
