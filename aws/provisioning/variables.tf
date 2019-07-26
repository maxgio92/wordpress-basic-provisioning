variable "app_name" {
  type        = "string"
  description = "The name of the application"
}

variable "env" {
  type        = "string"
  description = "The environment name. E.g.: 'demo', 'uat', 'staging', 'production', etc."
}

variable "vpc_cidr" {
  type        = "string"
  description = "The CIDR block of the VPC"
}

variable "public_subnet_count" {
  default     = "2"
  description = "How much public subnets to create"
}

variable "private_subnet_count" {
  default     = "0"
  description = "How much private subnets to create"
}

variable "aws_region" {
  default     = "eu-west-1"
  description = "The AWS region where to provision the resources"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "The instance type of the fullstack instance"
}

variable "ssh_key_name" {
  description = "The name of the SSH key to associate to the fullstack instance"
}

variable "ssh_ingress_cidr_block" {
  description = "The CIDR block allowed to access the fullstack instance via SSH"
}

variable "monitor_ingress_cidr_block" {
  description = "The CIDR block of the monitor to monitor the fullstack instance"
}

variable "monitor_ingress_port" {
  default     = 5666
  description = "The port to which the monitor communicate to monitor the fullstack instance"
}

variable "tls_certificate_arn" {
  description = "The ARN of the certificate to attach to the HTTPS listener of the load balancer"
}

variable "healthcheck_path" {
  default = "/"
}

variable "healthcheck_response_codes" {
  default = "200-299"
}
