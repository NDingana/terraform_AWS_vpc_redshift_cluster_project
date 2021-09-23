region               = "us-east-1"
vpc_cidr             = "10.0.0.0/16"
availability_zone    = ["us-east-1a", "us-east-1b","us-east-1c"]
public_subnet_names  = ["public_subnet_1a", "public_subnet_1b","public_subnet_1c"]
private_subnet_names = ["private_subnet_1a", "private_subnet_1b", "private_subnet_1c"]
public_subnet_cidr   = ["10.0.0.0/24", "10.0.4.0/24" ,  "10.0.8.0/24"]
private_subnet_cidr  = ["10.0.16.0/24", "10.0.24.0/24",  "10.0.32.0/24"]

