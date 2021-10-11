aws_region = "us-east-1"
project_name = "la-terraform"
vpc_cidr = "10.0.0.0/16"
public_cidr = [
    "10.0.1.0/24",
    "10.0.2.0/24"
    ]
priv_cidr = [
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    ]
accessip = "0.0.0.0/0"

#-------compute 

key_name = "tf_key"
public_key_path = "/home/ec2-user/.shh/id_rsa.pub"
instance_count = 2
instance_type = "t2.micro" 