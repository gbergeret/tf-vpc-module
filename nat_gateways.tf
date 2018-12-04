###
# EIP to control NAT IPs on Internet
##
resource "aws_eip" "nat" {
  count = "${length(data.aws_availability_zones.available.names)}"
}

###
# HA AWS NAT Gateway (expensive but HA ideal for production workload).
##
resource "aws_nat_gateway" "nat" {
  count = "${var.price_saving_enabled == "1" ? 0 : length(data.aws_availability_zones.available.names)}"

  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}

###
# Simple tiny EC2 instances to NAT internet access (not HA but cheap to test).
##
data "aws_ami" "nat" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-hvm-*"]
  }
}

resource "aws_instance" "nat" {
  count = "${var.price_saving_enabled == "1" ? length(data.aws_availability_zones.available.names) : 0}"

  instance_type = "t3.nano"
  ami           = "${data.aws_ami.nat.id}"

  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  subnet_id              = "${element(aws_subnet.public.*.id, count.index)}"
  source_dest_check      = false

  tags {
    Name = "${var.name_prefix}nat-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

resource "aws_eip_association" "nat" {
  count = "${var.price_saving_enabled == "1" ? length(data.aws_availability_zones.available.names) : 0}"

  instance_id   = "${element(aws_instance.nat.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
}

resource "aws_security_group" "nat" {
  count = "${var.price_saving_enabled == "1" ? 1 : 0}"

  name_prefix = "${var.name_prefix}nat-"
  vpc_id      = "${aws_vpc.v.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${aws_subnet.private.*.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
