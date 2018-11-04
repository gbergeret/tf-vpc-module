data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count = "${length(data.aws_availability_zones.available.names)}"

  vpc_id            = "${aws_vpc.v.id}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  # 3 new bits mean 8 subnets (should be enough as regions have maximum 6 AZs)
  cidr_block = "${cidrsubnet(aws_vpc.v.cidr_block, 3, count.index)}"

  map_public_ip_on_launch = true
}
