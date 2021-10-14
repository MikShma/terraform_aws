output "pub_security_group" {
   value = aws_security_group.tf_pub_sg.id
}

output "priv_security_group" {
   value = aws_security_group.tf_priv_sg.id
}

output "pub_subnets_id" {
   value = aws_subnet.tf_pub_subnet.*.id
}

output "priv_subnets_id" {
   value = aws_subnet.tf_priv_subnet.*.id
}

output "pub_subnet_ips" {
   value = aws_subnet.tf_pub_subnet.*.cidr_block
}

output "vpc_id" {
   value = aws_vpc.tf_vpc.id
}