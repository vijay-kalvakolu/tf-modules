#VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = var.vpc_tags
}
#public subnet (create atleast 2 for HA)
resource "aws_subnet" "public" {
  count             = length(var.pub_cidrs) # instead of using variable we are refering the list form pub_cidrs
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pub_cidrs[count.index]                        # when subnet one is creatd values it as 0, and second clunt as 1
  availability_zone = data.aws_availability_zones.az.names[count.index] #count is set according to the cidr block, as genarally in us-east-1 there are 6 AZs and in thios example we need 2
  tags = {
    name = "public-${count.index}" # used interpolation count.index as we have partially text and values. This is tag the reosurce like public-0, public-1.(if count is to be from 1 add +1 to interprotation)
  }
}

# Internet Gateway to make sure the subnets are reallay public
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-router"
  }
}

#Associate route table with public subnets

resource "aws_route_table_association" "public" {
  count          = length(var.pub_cidrs)
  subnet_id      = aws_subnet.public.*.id[count.index] # since we have more than 2 subnets we use .*.id[count.index]
  route_table_id = aws_route_table.public.id
}

#private subnet (create atleast 2 for HA)
resource "aws_subnet" "private" {
  count             = length(var.priv_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.priv_cidrs[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]
  tags = {
    name = "private-${count.index}"
  }
}

# Create NAT gateway tp enable private subnet to interact with internet
# make sure NAT gateway is not free