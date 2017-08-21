output "vpc_id" {
  value = "${aws_vpc.test.id}"
}

output "subnet_id" {
  value = "${aws_subnet.test.id}"
}

output "key_name" {
  value = "${aws_key_pair.test.key_name}"
}

output "security_group" {
  value = "${aws_security_group.test.id}"
}
