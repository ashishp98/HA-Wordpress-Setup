# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "wp-gw" {
  vpc_id = aws_vpc.wordpress.id

  tags = {
    Name = "wordpress gw"
  }
}

# Creating Route Tables for Internet gateway
resource "aws_route_table" "wp_routetable" {
  vpc_id = aws_vpc.wordpress.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wp-gw.id
  }

  tags = {
    Name = "wordpress routetable"
  }
}

# Creating Route Associations public subnets
resource "aws_route_table_association" "wp_rtable_assoc" {
  subnet_id      = aws_subnet.wp_subnet.id
  route_table_id = aws_route_table.wp_routetable.id
}

resource "aws_security_group" "ssh_http_allowed" {
    vpc_id = "${aws_vpc.wordpress.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ssh and http allowed"
    }
}