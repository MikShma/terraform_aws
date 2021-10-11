variable "aws_region" {
}
variable "project_name" {
}
variable "vpc_cidr" {  
}
variable "public_cidr" {
   type = list(string)
}
variable "priv_cidr" {
   type = list(string)
}
variable "accessip" {
  
}

#-------compute variables

variable key_name {
}

variable public_key_path {  
}

variable "instance_count" {
   default = 1
}

variable "instance_type" {
  
}