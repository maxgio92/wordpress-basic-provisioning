# VPC

#module "vpc" {
#  source = "github.com/maxgio92/terraform-aws-vpc"
#
#  prefix_name          = "${var.env}"
#  vpc_cidr             = "${var.vpc_cidr}"
#  public_subnet_count  = "${var.public_subnet_count}"
#  private_subnet_count = "${var.private_subnet_count}"
#}

# AMI

data "aws_caller_identity" "current" {}

data "aws_ami" "wordpress_basic" {
  owners = ["${data.aws_caller_identity.current.account_id}"]

  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-wordpress-basic"]
  }
}

# Instance

resource "aws_instance" "fullstack" {
  ami           = "${data.aws_ami.wordpress_basic.id}"
  instance_type = "${var.instance_type}"

  key_name = "${var.ssh_key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.all_instances.id}",
    "${aws_security_group.web_instances.id}",
  ]

  #subnet_id = "${module.vpc.public_subnet_ids[0]}"
  subnet_id = "${var.subnet_id}"

  tags = {
    Name        = "${var.env}-${var.app_name}-fullstack"
    Application = "${var.app_name}"
    Environment = "${var.env}"
  }
}

# Elastic IP

resource "aws_eip" "fullstack_instance" {
  instance = "${aws_instance.fullstack.id}"
}

# Security groups

resource "aws_security_group" "all_instances" {
  name = "all-instances"

  #vpc_id = "${module.vpc.vpc_id}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["${var.ssh_ingress_cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_instances" {
  name = "web-instances"

  #vpc_id = "${module.vpc.vpc_id}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
