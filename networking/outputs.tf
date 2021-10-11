output "pub_security_group" {
   value = aws_security_group.tf_pub_sg.id
}

output "pub_subnets_id" {
   value = aws_subnet.tf_pub_subnet.*.id
}

output "pub_subnet_ips" {
   value = aws_subnet.tf_pub_subnet.*.cidr_block
}