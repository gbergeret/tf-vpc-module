locals {
  "name_prefix" = "test-tf-vpc-module-"
}

module "vpc" {
  source = "../"

  name_prefix = "${local.name_prefix}"
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
  key_name_prefix = "${local.name_prefix}keypair"
  public_key      = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "i" {
  instance_type = "t2.micro"
  ami           = "${data.aws_ami.core.id}"
  subnet_id     = "${module.vpc.subnet_id}"
  key_name      = "${aws_key_pair.k.key_name}"

  vpc_security_group_ids = [
    "${module.vpc.security_group}",
  ]

  tags {
    Name = "${local.name_prefix}instance"
  }
}

output "instance_ip" {
  value = "${aws_instance.i.public_ip}"
}
