# VPC

module "vpc" {
  source = "github.com/maxgio92/terraform-aws-vpc"

  prefix_name          = "${var.env}"
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnet_count  = "${var.public_subnet_count}"
  private_subnet_count = "${var.private_subnet_count}"
}
