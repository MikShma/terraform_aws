#----networking----
data "aws_availability_zones" "available" {
}

resource "aws_vpc" "tf_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = "tf_vpc"
    }
  
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf_igw"
  }
}

resource "aws_route_table" "tf_public_route" {
    vpc_id = aws_vpc.tf_vpc.id
    route = [ {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.tf_igw.id
    } ]
  tags = {
    Name = "pub_routetbl"
  }
}

resource "aws_default_route_table" "tf_priv_routetb" {
    default_route_table_id = aws_vpc.tf_vpc.default_route_table_id
    tags = {
      Name = "priv_routetbl"
    }
  
}

resource "aws_subnet" "tf_pub_subnet" {
    count = length(var.public_cidr)
    vpc_id = aws_vpc.tf_vpc.id
    cidr_block = var.public_cidr[count.index]
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
      Name = "pub_subnet_${count.index+1}"
    }
  
}

resource "aws_route_table_association" "tf_pub_assoc" {
    count = aws_subnet.tf_pub_subnet.count
    subnet_id = aws_subnet.tf_pub_subnet.*.id[count.index]
    route_table_id = aws_route_table.tf_public_route.id
  
}

resource "aws_security_group" "tf_pub_sg" {
    name = "tf_pub_sg"
    description = "tf_pub_sg"
    vpc_id = aws_vpc.tf_vpc.id

    ingress = [ {
      from_port = 22
      to_port = 22
      protocol         = "tcp"
      cidr_blocks      = ["${var.accessip}"]
    } ,
  
    {
      from_port = 80
      to_port = 80
      protocol         = "tcp"
      cidr_blocks      = ["${var.accessip}"]
    } ]

    egress = [ {
      from_port = 0
      to_port = 0
      protocol         = "-1"
      cidr_blocks      = ["${var.accessip}"]
    } ]
}

resource "aws_subnet" "tf_priv_subnet" {
    count = length(var.priv_cidr)
    vpc_id = aws_vpc.tf_vpc.id
    cidr_block = var.priv_cidr[count.index]
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
      Name = "priv_subnet_${count.index+1}"
    }
  
}

resource "aws_route_table_association" "tf_priv_assoc" {
    count = length(aws_subnet.tf_priv_subnet)
    subnet_id = aws_subnet.tf_priv_subnet.*.id[count.index]
    route_table_id = aws_default_route_table.tf_priv_routetb.id
  
}

resource "aws_security_group" "tf_priv_sg" {
    name = "tf_priv_sg"
    description = "tf_priv_sg"
    vpc_id = aws_vpc.tf_vpc.id

    ingress = [ {
      from_port = 22
      to_port = 22
      protocol         = "tcp"
      cidr_blocks      = ["${var.vpc_cidr}"]
    } ]

    egress = [ {
      from_port = 0
      to_port = 0
      protocol         = "-1"
      cidr_blocks      = ["${var.vpc_cidr}"]
    } ]
}
