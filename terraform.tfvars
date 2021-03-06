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
priv_key_path = "/home/ec2-user/.ssh/id_rsa.pem"
instance_count = 1
instance_type = "t2.micro" 

db_name = "test"

db_user = "admin"

db_pass = "123456"