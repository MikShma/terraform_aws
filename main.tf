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