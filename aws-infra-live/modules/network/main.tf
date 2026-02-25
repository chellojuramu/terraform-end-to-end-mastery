terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.33"
    }
  }
}
########################################
# Fetch Available AZs (Dynamic)
########################################

data "aws_availability_zones" "available" {
  state = "available"
}

########################################
# Create VPC
########################################

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-vpc"
    }
  )
}
########################################
# Internet Gateway
########################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-igw"
    }
  )
}
########################################
# Public Subnets (Multi-AZ using for_each)
########################################
resource "aws_subnet" "public" {
  for_each = {
    for index,cidr in var.public_subnet_cidrs :
    index => cidr
  }
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available.names[each.key]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-public-${each.key}"
      Type = "public"
    }
  )
}

########################################
# Private Subnets
########################################
resource "aws_subnet" "private" {
  for_each = {
    for index,cidr in var.private_subnet_cidrs :
    index => cidr
  }
  vpc_id = aws_vpc.this.id
  cidr_block = each.value
  availability_zone = data.aws_availability_zones.available.names[each.key]
  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-private-${each.key}"
      Type = "private"
    }
  )
}
########################################
# Public Route Table
########################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge (
    var.common_tags,
    {
      Name = "${var.environment}-public-rt"
    }
  )
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}
########################################
# Associate Public Subnets with Public RT
########################################

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id = each.value.id
  route_table_id = aws_route_table.public.id
}

########################################
# NAT Gateway (Optional - Production Use)
########################################

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
}
resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id = values(aws_subnet.public) [0].id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-nat"
    }
  )
    depends_on = [aws_internet_gateway.this]
}

########################################
# Private Route Table
########################################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-private-rt"
    }
  )
}
resource "aws_route" "private_nat_route" {
  count = var.enable_nat_gateway ? 1 : 0
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
}

########################################
# Associate Private Subnets
########################################
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id = each.value.id
  route_table_id = aws_route_table.private.id
}