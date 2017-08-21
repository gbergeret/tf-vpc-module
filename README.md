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

  name_prefix = "${var.name_prefix}"
}

variable "aws_region" {}

variable "name_prefix" {}
```
