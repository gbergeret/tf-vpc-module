output "vpc_id" {
  value = "${aws_vpc.v.id}"
}

output "default_security_group" {
  value = "${aws_default_security_group.d.id}"
}

output "subnets" {
  value = {
    public = ["${aws_subnet.public.*.id}"]
  }
}

output "cidr_blocks" {
  value = {
    vpc    = ["${aws_vpc.v.cidr_block}"]
    public = ["${aws_subnet.public.*.cidr_block}"]
  }
}
