# Configure the AWS Provider
provider "aws" {
    region = "eu-west-1"
    profile = "devops"
}

variable "cidr_blocks" {
    description = "CIDR Block & Name Tags for VPC & Subnet"
    type = list(object({
        cidr_block = string
        name = string
    }))
}

resource "aws_vpc" "development-vpc" {
    cidr_block = var.cidr_blocks[0].cidr_block
    tags = {
        Name = var.cidr_blocks[0].name
    }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = "eu-west-1a"
    tags = {
        Name = var.cidr_blocks[1].name
    }
}
