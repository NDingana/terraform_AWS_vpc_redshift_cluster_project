
resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW_TF.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
  depends_on = [aws_vpc.mainvpc, aws_internet_gateway.IGW_TF]
}


# we associate all three public subnets with the one PublicRouteTable created above
resource "aws_route_table_association" "publicroutetableassociation" {
  count = length(var.public_subnet_cidr)

  /*
If var.list is a list of objects that all have an attribute id, 
then a list of the ids could be produced with the following for expression:

[for o in var.list : o.id]
This is equivalent to the following splat expression:
var.list[*].id
The special [*] symbol iterates over all of the elements of the list given to its left
 and accesses from each one the attribute name given on its right.

*/
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.PublicRouteTable.id
  depends_on     = [aws_subnet.public_subnets, aws_route_table.PublicRouteTable]
}

# we can use the one PrivateRouteTable for the two private subnets
# we add a route in the PrivateRouteTable to the aws_nat_gateway
# This way both private subnets can have access to the internet.
# The aws_nat_gateway itself will be kept in one of the public subnets
resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NATGW.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
  depends_on = [aws_vpc.mainvpc, aws_nat_gateway.NATGW]
}

# we associate all three private subnets with the one PrivateRouteTable created above
resource "aws_route_table_association" "privateroutetableassociation" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.PrivateRouteTable.id
  depends_on     = [aws_subnet.private_subnets, aws_route_table.PrivateRouteTable]
}

