provider "aws" {
    region = "${var.aws_region}"
}

#create ssh key
resource "null_resource" "cluster" {
    provisioner "local-exec" {
    command = fileexists("${var.priv_key_path}") ? "echo \"ssh key exist\"" : "ssh-keygen -t rsa -N \"\" -f ${var.priv_key_path}"
  }
}

#deploy storage
module "storage" {
    source = "./storage"
    project_name = "${var.project_name}"
  
}

#deploy network

module "networking" {
    source = "./networking"
    vpc_cidr = var.vpc_cidr
    public_cidr = var.public_cidr
    priv_cidr = var.priv_cidr
    accessip = var.accessip
}

module "compute" {
    source = "./computeEC2"
    key_name = var.key_name
    public_key_path = format("%s.pub",var.priv_key_path)
    instance_count = var.instance_count
    instance_type = var.instance_type
    security_group = module.networking.pub_security_group
    subnets = module.networking.pub_subnets_id
    subnet_ips = module.networking.pub_subnet_ips
    priv_subnet_ids = module.networking.priv_subnets_id
    priv_security_group =  module.networking.priv_security_group
}