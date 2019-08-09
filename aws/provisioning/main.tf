# AMI

data "aws_caller_identity" "current" {}

data "aws_ami" "wordpress_basic" {
  owners = ["${data.aws_caller_identity.current.account_id}"]

  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-${var.env}-wordpress-basic"]
  }
}

# Instance

data "template_file" "fullstack_instance_user_data" {
  template = "${file("aws_instance_fullstack/user_data.bash.tpl")}"

  vars = {
    app_name = "${var.app_name}"
  }
}

resource "aws_instance" "fullstack" {
  ami           = "${data.aws_ami.wordpress_basic.id}"
  instance_type = "${var.instance_type}"

  key_name = "${var.ssh_key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.all_instances.id}",
    "${aws_security_group.web_instances.id}",
    "${aws_security_group.ftp_instances.id}",
    "${aws_security_group.monitored_instances.id}",
  ]

  subnet_id = "${module.vpc.public_subnet_ids[0]}"

  user_data = "${data.template_file.fullstack_instance_user_data.rendered}"

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

  vpc_id = "${module.vpc.vpc_id}"

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

  vpc_id = "${module.vpc.vpc_id}"

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

resource "aws_security_group" "ftp_instances" {
  name = "ftp-instances"

  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 20
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "FTP active mode ports"
  }

  ingress {
    from_port   = 21100
    to_port     = 21110
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "FTP passive mode ports"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "monitored_instances" {
  name = "monitored-instances"

  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port = "${var.monitor_ingress_port}"
    to_port   = "${var.monitor_ingress_port}"
    protocol  = "tcp"

    cidr_blocks = ["${var.monitor_ingress_cidr_block}"]
  }

  ingress {
    from_port = "-1"
    to_port   = "-1"
    protocol  = "icmp"

    cidr_blocks = ["${var.monitor_ingress_cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
