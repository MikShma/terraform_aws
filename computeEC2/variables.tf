variable key_name {
}

variable priv_key_path {  
}

variable "instance_count" {
}

variable "instance_type" {
  
}

variable "security_group" {
  
}

variable "subnets" {
   type = list(string)   
}

variable "subnet_ips" {
   type = list(string)  
}

variable "priv_subnet_ids" {
   type = list(string)  
}

variable "priv_security_group" {
  
}