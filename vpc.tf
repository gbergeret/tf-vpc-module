resource "aws_vpc" "test" {
  cidr_block = "192.168.1.0/24"
}

resource "aws_internet_gateway" "test" {
  vpc_id = "${aws_vpc.test.id}"
}

resource "aws_subnet" "test" {
  vpc_id     = "${aws_vpc.test.id}"
  cidr_block = "${aws_vpc.test.cidr_block}"

  map_public_ip_on_launch = true
}

resource "aws_route_table" "test" {
  vpc_id = "${aws_vpc.test.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test.id}"
  }
}

resource "aws_route_table_association" "test" {
  subnet_id      = "${aws_subnet.test.id}"
  route_table_id = "${aws_route_table.test.id}"
}
