resource "aws_key_pair" "test" {
  key_name_prefix = "${var.name_prefix}-keypair"
  public_key      = "${file("~/.ssh/id_rsa.pub")}"
}
