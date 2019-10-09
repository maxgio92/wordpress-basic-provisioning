module "lb" {
  source = "git::https://github.com/maxgio92/terraform-aws-load-balancer.git?ref=1.0.0"

  subnet_ids      = "${module.vpc.public_subnet_ids}"
  internal        = false
  listeners_count = 1

  listeners = [
    {
      port     = 80
      protocol = "HTTP"
    },
  ]

  tls_listeners_count = 1

  tls_listeners = [
    {
      port            = 443
      certificate_arn = "${var.tls_certificate_arn}"
    },
  ]

  security_group_public_rules_count = 2

  security_group_public_rules = [
    {
      port   = 80
      source = "0.0.0.0/0"
    },
    {
      port     = 443
      protocol = "tcp"
      source   = "0.0.0.0/0"
    },
  ]

  default_target_group_healthcheck_path           = "${var.healthcheck_path}"
  default_target_group_healthcheck_response_codes = "${var.healthcheck_response_codes}"

  prefix_name = "${var.env}-${var.app_name}"
}

resource "aws_lb_target_group_attachment" "lb_web" {
  target_group_arn = "${module.lb.default_target_group_arn}"
  target_id        = "${aws_instance.fullstack.id}"
}
