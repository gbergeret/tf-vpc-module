variable "name_prefix" {
  default = "tf-consul-module-test-"
}

module "vpc" {
  source = "../"

  name_prefix = "tf-test-vpc-module-test-"
}

data "aws_ami" "core" {
  most_recent = true
  owners      = ["595879546273"]

  filter {
    name   = "name"
    values = ["CoreOS-stable*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "instance" {
  instance_type = "t2.small"
  ami           = "${data.aws_ami.core.id}"
  subnet_id     = "${module.vpc.subnet_id}"
  key_name      = "${module.vpc.key_name}"

  vpc_security_group_ids = [
    "${module.vpc.security_group}",
  ]

  tags {
    Name = "${var.name_prefix}instance"
  }
}
