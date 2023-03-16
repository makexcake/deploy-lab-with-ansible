terraform {
    required_version = ">=0.12"
    backend "s3" {
      bucket = "vit-envs"
      key = "deploy-lab/terraform.tfstate"
      region = "eu-central-1"
    }   
}

provider "aws" {}
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable instance_type {}
#ansible vars
variable ssh_private_key {}


# create vpc 
resource "aws_vpc" "mylab-vpc" {
    cidr_block = var.vpc_cidr_block

    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

# create subnet
resource "aws_subnet" "mylab-subnet-1" {
    vpc_id = aws_vpc.mylab-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone

    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

# create internet gateway
resource "aws_internet_gateway" "mylab-igw" {
    vpc_id = aws_vpc.mylab-vpc.id

    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

# create route table
resource "aws_route_table" "mylab-route-table" {
    vpc_id = aws_vpc.mylab-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.mylab-igw.id
    }

    tags = {
        Name: "${var.env_prefix}-rtb"
    }
}

# associate route table with subnet
resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.mylab-subnet-1.id
    route_table_id = aws_route_table.mylab-route-table.id
}



