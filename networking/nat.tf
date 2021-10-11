resource "aws_eip" "tf_el_ip" {
  vpc      = true
}

resource "aws_nat_gateway" "tf_pub_nat" {
  allocation_id = aws_eip.tf_el_ip.id
  subnet_id     = aws_subnet.tf_pub_subnet.1.id

  tags = {
    Name = "TF pub NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.tf_igw]
}