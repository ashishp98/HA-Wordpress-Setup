resource "aws_vpc" "wordpress" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "wordpress vpc"
  }
}

# Creating Public Subnets in VPC
resource "aws_subnet" "wp_subnet" {
  vpc_id                  = aws_vpc.wordpress.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "wp subnet public"
  }
}