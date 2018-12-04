data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count = "${length(data.aws_availability_zones.available.names)}"

  vpc_id            = "${aws_vpc.v.id}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  # 5 new bits mean 32 subnets (should be enough as regions have maximum 6 AZs).
  # bare in mind the 24 last CIDR blocks are used by private subnets.
  cidr_block = "${cidrsubnet(aws_vpc.v.cidr_block, 5, count.index)}"

  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = "${length(data.aws_availability_zones.available.names)}"

  vpc_id            = "${aws_vpc.v.id}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  # 3 new bits mean 8 subnets (should be enough as regions have maximum 6 AZs).
  # only up to 6 subnets can be allocated privately (2 first CIDR blocks are used
  # by public subnets). 
  cidr_block = "${cidrsubnet(aws_vpc.v.cidr_block, 3, 2 + count.index)}"
}
