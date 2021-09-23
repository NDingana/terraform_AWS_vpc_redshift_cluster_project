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

