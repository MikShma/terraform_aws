# Pub NACL rules
resource "aws_network_acl" "tf_pub_acl" {
  vpc_id = aws_vpc.tf_vpc.id
  count = length(aws_subnet.tf_pub_subnet)
  subnet_ids = aws_subnet.tf_pub_subnet.*.id[count.index]
  ingress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    }

  ingress {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
    }

  ingress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }

  ingress {
      protocol   = "tcp"
      rule_no    = 130
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 22
      to_port    = 22
    }

  egress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    }

  egress {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
    }
  egress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }

  egress {
      protocol   = "tcp"
      rule_no    = 130
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 22
      to_port    = 22
    }
}

# Priv NACL rules
resource "aws_network_acl" "tf_priv_acl" {
  vpc_id = aws_vpc.tf_vpc.id
  count = length(aws_subnet.tf_priv_subnet)
  subnet_ids = aws_subnet.tf_priv_subnet.*.id[count.index]

    ingress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "10.0.0.0/16"
      from_port  = 22
      to_port    = 22
    }

    ingress {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "10.0.0.0/16"
      from_port  = 3306
      to_port    = 3306
    }
    
    ingress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "10.0.0.0/16"
      from_port  = 80
      to_port    = 80
    }

  ingress {
      protocol   = "tcp"
      rule_no    = 130
      action     = "allow"
      cidr_block = "10.0.0.0/16"
      from_port  = 1024
      to_port    = 65535
    }

    egress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "10.0.0.0/16"
      from_port  = 22
      to_port    = 22
    }

  egress {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "10.0.0.0/16"
      from_port  = 3306
      to_port    = 3306
    }

  egress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "10.0.0.0/16"
      from_port  = 80
      to_port    = 80
    }

}