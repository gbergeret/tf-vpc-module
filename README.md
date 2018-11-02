# VPC Module

AWS VPC module to create VPCs in AWS.

## How To Use

### Parameters
`name_prefix`: String (optional, default: `tf-test-`)

### Sample
```hcl
module "consul" {
  source = "github.com/gbergere/tf-vpc-module"
}
```

## Used by
* [tf-consul-module](https://github.com/gbergere/tf-consul-module)
