###
# Module call (module to test)
##
variable "price_saving_enabled" {}

module "vpc" {
  source = "../../../"

  name_prefix = "${local.name_prefix}"

  price_saving_enabled = "${var.price_saving_enabled}"
}

###
# Misc
##
locals {
  "name_prefix" = "test-tf-vpc-module-"
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

resource "aws_key_pair" "k" {
  key_name_prefix = "${local.name_prefix}keypair-"
  public_key      = "${file("~/.ssh/id_rsa.pub")}"
}

resource "random_integer" "az" {
  min = 0
  max = "${length(module.vpc.subnets["public"]) - 1}" # -1 as the max value is inclusive
}

###
# Dummy Instance to run test from
##
resource "aws_instance" "i" {
  instance_type = "t3.nano"
  ami           = "${data.aws_ami.core.id}"
  subnet_id     = "${element(module.vpc.subnets["private"], random_integer.az.result)}"
  key_name      = "${aws_key_pair.k.key_name}"

  vpc_security_group_ids = ["${module.vpc.default_security_group}"]

  tags {
    Name = "${local.name_prefix}dummy-instance"
  }
}

output "instance_ip" {
  value = "${aws_instance.i.private_ip}"
}

###
# SSH Bastion to reach dummy instance
##
resource "aws_instance" "b" {
  instance_type = "t3.nano"
  ami           = "${data.aws_ami.core.id}"
  subnet_id     = "${element(module.vpc.subnets["public"], random_integer.az.result)}"
  key_name      = "${aws_key_pair.k.key_name}"

  vpc_security_group_ids = [
    "${module.vpc.default_security_group}",
    "${aws_security_group.bastion.id}",
  ]

  tags {
    Name = "${local.name_prefix}dummy-bastion"
  }
}

resource "aws_security_group" "bastion" {
  name_prefix = "${local.name_prefix}-ec2-ssh-bastion-"
  vpc_id      = "${module.vpc.vpc_id}"

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${module.vpc.cidr_blocks["private"]}"]
  }
}

output "bastion_ip" {
  value = "${aws_instance.b.public_ip}"
}
