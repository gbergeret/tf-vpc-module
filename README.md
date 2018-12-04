# VPC Module

AWS VPC module to create a basic VPCs with 1 public subnet per AZ in AWS.

_This module can run in money saving mode so you don't spend crazy amount while
running tests. You simply need to use the variable `price_saving_enabled`._

## How To Use

### Variables

* `name_prefix`: String (optional, default: `tf-`)
* `cidr_block`: String needs to be at least `/23` 
  (optional, default: `172.31.0.0/16`)
* `price_saving_enabled`: Bool used to reduce cost by using EC2 instances as NAT
  gateway instead of AWS NAT Gateway (optional, default: `false`)

### Outputs

* `vpc_id`: String 
* `default_security_group`: String
* `subnets`: Map\[List]: list of subnet ids per tier (_public_, _private_)
* `cidr_blocks`: Map\[List]: list of CIDR blocks per tier (_vpc_, _public_, _private_)

### Example

```hcl
module "vpc" {
  source = "github.com/gbergere/tf-vpc-module"
}
```

## Used by

* [micro-service-as-code](https://github.com/gbergere/micro-service-as-code)
