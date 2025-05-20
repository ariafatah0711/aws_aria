terraform {
 required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
    }
 }

 required_version = ">= 1.2.0"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "app_server" {
    ami           = "ami-04f167a56786e4b09"
    instance_type = "t2.micro"
    key_name = "ariaf"
    vpc_security_group_ids = [aws_security_group.web_ssh.id]
    user_data = file("${path.module}/user_data.sh")
    tags = {
        Name = var.instance_name
    }
}

variable "instance_name" {
    description = "name of instance"
    type = string
    default = "Terraform 1"
}

output "instance_id" {
    description = "ID of  the EC2 instance"
    value       = aws_instance.app_server.id
}

output "instance_public_ip" {
    description = "Public IP of the EC2 instance"
    value       = aws_instance.app_server.public_ip
}

output "web_linktree" {
  description = "Link to the deployed web page"
  value       = "http://${aws_instance.app_server.public_ip}"
}

# security group
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
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