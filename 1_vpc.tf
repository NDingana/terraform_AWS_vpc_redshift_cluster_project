resource "aws_vpc" "mainvpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "VPC_TF"
  }

}
resource "aws_internet_gateway" "IGW_TF" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "IGW_TF"
  }
  depends_on = [aws_vpc.mainvpc]
}

resource "aws_eip" "EIP" {
  vpc = true
  tags = {
    Name = "EIP"
  }

}

# The aws_nat_gateway itself will be kept in one of the public subnets 
resource "aws_nat_gateway" "NATGW" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "NATGW"
  }
  depends_on = [aws_eip.EIP, aws_subnet.public_subnets]

}

#############################################################################################################
############################################# public_subnets ################################################
#############################################################################################################

resource "aws_subnet" "public_subnets" {

  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = element(var.public_subnet_cidr, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${element(var.public_subnet_names, count.index)}"
  }
  depends_on = [aws_vpc.mainvpc]
}

#############################################################################################################
############################################# private_subnets ################################################
#############################################################################################################
resource "aws_subnet" "private_subnets" {

  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)


  tags = {
    Name = "${element(var.private_subnet_names, count.index)}"
  }
  depends_on = [aws_vpc.mainvpc]
}