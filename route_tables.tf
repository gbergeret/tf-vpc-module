resource "aws_default_route_table" "public" {
  default_route_table_id = "${aws_vpc.v.main_route_table_id}"
}

resource "aws_route" "public_default" {
  route_table_id         = "${aws_default_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.i.id}"
}

resource "aws_route_table" "private" {
  count = "${length(data.aws_availability_zones.available.names)}"

  vpc_id = "${aws_vpc.v.id}"
}

resource "aws_route" "private_default_ec2" {
  count = "${var.price_saving_enabled == "1" ? length(data.aws_availability_zones.available.names) : 0}"

  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = "${element(aws_instance.nat.*.id, count.index)}"
}

resource "aws_route" "private_default_nat_gateway" {
  count = "${var.price_saving_enabled == "1" ? 0 : length(data.aws_availability_zones.available.names)}"

  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat.*.id, count.index)}"
}

resource "aws_route_table_association" "private" {
  count = "${length(data.aws_availability_zones.available.names)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
