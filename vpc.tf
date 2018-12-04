resource "aws_vpc" "v" {
  cidr_block = "${var.cidr_block}"
}

resource "aws_internet_gateway" "i" {
  vpc_id = "${aws_vpc.v.id}"
}
