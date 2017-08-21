# VPC Test Module

AWS VPC module to test terraform modules.

## How To Use

### Parameters
`name_prefix`: String (optional, default: `tf-test-`)

### Sample
```hcl
provider "aws" {
  region = "${var.aws_region}"
}

module "consul" {
  source = "github.com/gbergere/tf-vpc-test-module"
}

variable "aws_region" {}
```

## Used by
* [tf-consul-module](https://github.com/gbergere/tf-consul-module)
