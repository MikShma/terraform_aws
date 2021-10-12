#-----compute/main.tf

data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "tf_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "pub_bastion_host" {
  count         = var.instance_count
  instance_type = var.instance_type
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "tf_pub_bastion_server-${count.index +1}"
  }
  key_name               = aws_key_pair.tf_auth.id
  vpc_security_group_ids = [var.security_group]
  subnet_id              = var.subnets[count.index]
  user_data = templatefile("${path.module}/userdata.tpl", {firewall_subnets = var.subnet_ips[count.index]})  
}

resource "aws_instance" "priv_app_host" {
  count         = 1
  instance_type = var.instance_type
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "tf_priv_app_host-${count.index +1}"
  }
  key_name               = aws_key_pair.tf_auth.id
  vpc_security_group_ids = [var.priv_security_group]
  subnet_id              = var.priv_subnet_ids[count.index]
  user_data = templatefile("${path.module}/userdata.tpl", {firewall_subnets = "priv_subnet"})  
}