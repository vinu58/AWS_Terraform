provider "aws" {
  profile    = "default"
  region     = "us-west-2"
}

resource "aws_vpc" "Flask" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "dedicated"

  tags = {
    Name = "Flask"
    }
}

# create the Subnet
resource "aws_subnet" "Flask_Subnet" {
  vpc_id                  = aws_vpc.Flask.id
  cidr_block              = var.subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
tags = {
   Name = "Flask Subnet"
    }
}

# Create the Security Group
resource "aws_security_group" "Flask_Security_Group" {
  vpc_id       = aws_vpc.Flask.id
  name         = "Flask Security Group"
  description  = "Flask Security Group"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
tags = {
   Name = "Flask"
   Description = "Flask Security Group"
    }
} 

# create VPC Network access control list
resource "aws_network_acl" "Flask_Security_ACL" {
  vpc_id = aws_vpc.Flask.id
  subnet_ids = [ aws_subnet.Flask_Subnet.id ]
# allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 22
    to_port    = 22
  }
  
  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 80
    to_port    = 80
  }
  
  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
  
  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22 
    to_port    = 22
  }
  
  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80  
    to_port    = 80 
  }
 
  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
tags = {
    Name = "Flask"
    }
} 

# Create the Internet Gateway
resource "aws_internet_gateway" "Flask_GW" {
 vpc_id = aws_vpc.Flask.id
 tags = {
        Name = "Flask Internet Gateway"
    }
} 

# Create the Route Table
resource "aws_route_table" "Flask_route_table" {
 vpc_id = aws_vpc.Flask.id
 tags = {
        Name = "Flask Route Table"
}
} 

# Create the Internet Access
resource "aws_route" "My_VPC_internet_access" {
  route_table_id         = aws_route_table.Flask_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.Flask_GW.id
} 

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "Flask_association" {
  subnet_id      = aws_subnet.Flask_Subnet.id
  route_table_id = aws_route_table.Flask_route_table.id
}



