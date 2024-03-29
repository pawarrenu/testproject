# Internet Gateway
resource "aws_internet_gateway" "web_gw" {
  vpc_id = aws_vpc.test_vpc.id
}

# route table for public subnet - connecting to Internet gateway
resource "aws_route_table" "web_rt_public" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_gw.id
  }
}

# associate the route table with public subnet 1
resource "aws_route_table_association" "web_rta1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.web_rt_public.id
}
# associate the route table with public subnet 2
resource "aws_route_table_association" "web_rta2" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.web_rt_public.id
}
