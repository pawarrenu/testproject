resource "aws_eip" "web_eip" {
  depends_on = [aws_internet_gateway.web_gw]
  vpc        = true
  tags = {
    Name = "web_EIP_for_NAT"
  }
}

# NAT gateway for private subnets
# (for the private subnet to access internet - eg. ec2 instances downloading softwares from internet)
resource "aws_nat_gateway" "web_nat_for_private_subnet" {
  allocation_id = aws_eip.web_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id # nat should be in public subnet

  tags = {
    Name = "Sh NAT for private subnet"
  }

  depends_on = [aws_internet_gateway.web_gw]
}

# route table - connecting to NAT
resource "aws_route_table" "web_rt_private" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.web_nat_for_private_subnet.id
  }
}

# associate the route table with private subnet
resource "aws_route_table_association" "web_rta3" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.web_rt_private.id
}
