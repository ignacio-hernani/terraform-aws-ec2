# Provider Block

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.56.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "eu-west-2"
}

# Instance

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-0fe310dde2a8fdc5c" # us-west-2
  instance_type = "t2.small"
  tags = {
    Name = var.instance_name
  }

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }


}

variable "instance_name" {}
variable "vpc_name" {}
