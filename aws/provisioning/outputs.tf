output "endpoint" {
  value = "${aws_eip.fullstack_instance.public_ip}"
}
