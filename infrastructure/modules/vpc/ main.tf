
locals {
  name = "${lower(var.project_name)}-${var.environment}"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    "Name" = "${local.name}-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${local.name}-pub-sub-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${local.name}-pub-sub-2"
  }
}

# resource "aws_subnet" "private-subnet-1" {
#   vpc_id = aws_vpc.main.id
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "${var.aws_region}c"
#   map_public_ip_on_launch = false

#   tags = {
#     "Name" = "Private Subnet 1"
#   }
# }

# resource "aws_subnet" "private-subnet-2" {
#   vpc_id = aws_vpc.main.id
#   cidr_block = "10.0.3.0/24"
#   availability_zone = "${var.aws_region}d"
#   map_public_ip_on_launch = false

#   tags = {
#     "Name" = "Private Subnet 2"
#   }
# }

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${local.name}-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id  
  tags = {
    "Name" = "${local.name}-pub-route-table"
  }
}

resource "aws_route" "route" {
  route_table_id              = "${aws_route_table.public_route_table.id}"
  destination_cidr_block                  = "0.0.0.0/0"
  gateway_id                  = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_subnet_1-route-table-association" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2-route-table-association" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

