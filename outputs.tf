output "vpc_id" {
  value = "${aws_vpc.v.id}"
}

output "subnet_id" {
  value = "${aws_subnet.s.id}"
}

output "security_group" {
  value = "${aws_default_security_group.d.id}"
}
