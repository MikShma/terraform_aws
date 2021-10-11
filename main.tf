provider "aws" {
    region = "${var.aws_region}"
}

#deploy storage
module "storage" {
    source = "./storage"
    project_name = "${var.project_name}"
  
}

#deploy network

module "network" {
    source = "./networking"
    vpc_cidr = var.vpc_cidr
    public_cidr = var.public_cidr
    priv_cidr = var.priv_cidr
    accessip = var.accessip
}

module "compute" {
    source = "./computeEC2"
    key_name = var.key_name
    public_key_path = var.public_key_path
    instance_count = var.instance_count
    instance_type = var.instance_type
    security_group = module.networking.pub_security_group
    subnets = module.networking.pub_subnets_id
    subnet_ips = module.networking.pub_subnet_ips
}