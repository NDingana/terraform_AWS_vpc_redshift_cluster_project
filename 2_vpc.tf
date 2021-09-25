
provider "aws" {
  region = "us-east-1"
}

#############################################################################################################
############################################# aws_vpc #######################################################
#############################################################################################################

resource "aws_vpc" "mainvpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "VPC_TF"
  }

}

#############################################################################################################
############################################# public_subnets ################################################
#############################################################################################################

############################################# public_subnet_1 ################################################
# Frist Public subnet with name tag public_subnet_1a in us-east-1a AZ
resource "aws_subnet" "public_subnet_1" {
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.mainvpc.id
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_1a"
  }
  depends_on = [aws_vpc.mainvpc]
}

############################################# public_subnet_2 ################################################
# second Public subnet with name tag public_subnet_2b in us-east-1b AZ
resource "aws_subnet" "public_subnet_2" {
  cidr_block              = "10.0.4.0/24"
  vpc_id                  = aws_vpc.mainvpc.id
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2b"
  }
  depends_on = [aws_vpc.mainvpc]
}

############################################# public_subnet_3 ################################################
# Third Public subnet with name tag public_subnet_3c in us-east-1c AZ
resource "aws_subnet" "public_subnet_3" {
  cidr_block              = "10.0.8.0/24"
  vpc_id                  = aws_vpc.mainvpc.id
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_3c"
  }
  depends_on = [aws_vpc.mainvpc]
}

#############################################################################################################
############################################# IGW_TF ########################################################
#############################################################################################################
resource "aws_internet_gateway" "IGW_TF" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "IGW_TF"
  }
  depends_on = [aws_vpc.mainvpc]
}

#############################################################################################################
############################### one public aws_route_table ##################################################
#############################################################################################################

######################################### public-route-table ################################################
#  All three public subnets will share a single route table, 
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.mainvpc.id

  # we create a route in the public_route_table to the aws_internet_gateway
  # by doing this, all our three subnets that will be associated with this rout table will be public.
  # THerefore,ec2 instances in the public subnet can reach the internet for inbound and outbound connections

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW_TF.id
  }
  tags = {
    Name = "public_route_table"
  }

  depends_on = [aws_vpc.mainvpc, aws_internet_gateway.IGW_TF]
}

#############################################################################################################
############################## Three public-route-association ###############################################
#############################################################################################################

# All three public subnets will share a single public route table, 
# so here we associate all three public subnets to the public_route_table created above

resource "aws_route_table_association" "public_subnet_1_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_2.id
}

resource "aws_route_table_association" "public_subnet_3_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_3.id
}

#############################################################################################################
############################## ec2_public_security_group ####################################################
#############################################################################################################

resource "aws_security_group" "ec2_public_security_group" {

  description = "Internet reaching access for public ec2s"
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_public_security_group"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.mainvpc]
}

#############################################################################################################
############### aws_iam_role, aws_iam_role_policy_attachment and aws_iam_instance_profile  ##################
#############################################################################################################

# Let’s create a role now that we want to attach to our EC2 instances:
# You create a s3_bucket_role and assign the role to an EC2 instance at boot time
# You give the role the permissions for read only access for all resources 
resource "aws_iam_role" "s3_bucket_role" {
  name               = "s3_bucket_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

# Now we need to add some permissions using a policy document:
# we are using an aws managed policy here called AmazonS3ReadOnlyAccess
# by default it will allow reads only on all s3 objects by all aws resources
# json can be viewed at link below for details
# https://gist.github.com/bernadinm/6f68bfdd015b3f3e0a17b2f00c9ea3f8
resource "aws_iam_role_policy_attachment" "s3-policy-attach" {
  role       = aws_iam_role.s3_bucket_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


# aws_iam_instance_profile is what we will use to attach it to our ec2 instance.
# Any instance that will use this s3_readOnly_instance_profile 
# will have the access to read all s3 objects
resource "aws_iam_instance_profile" "s3_readOnly_instance_profile" {
  name = "s3_readOnly_instance_profile"
  role = aws_iam_role.s3_bucket_role.name
}


