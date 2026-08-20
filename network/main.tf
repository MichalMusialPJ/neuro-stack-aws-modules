locals {
  len_public_subnets  = length(var.public_subnets)
  len_private_subnets = length(var.private_subnets)
  nat_gateway_ips     = aws_eip.nat[*].id
}

# locals {
#   name   = "ex-${basename(path.cwd)}"
#   region = "eu-west-1"

#   vpc_cidr = "10.0.0.0/16"
#   azs      = slice(data.aws_availability_zones.available.names, 0, 3)

#   tags = {
#     Example    = local.name
#     GithubRepo = "terraform-aws-vpc"
#     GithubOrg  = "terraform-aws-modules"
#   }
# }

resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  region           = var.region
  cidr_block       = var.cidr
  instance_tenancy = var.instance_tenancy


  tags = merge(
    { "Name" = format("%s-vpc", var.name_prefix) },
    var.tags
  )
}


### RECONSIDER ADDING FOR_EACH INSTEAD OF COUNT AND PASS LIST OF SUBNETS TO CREATE LESS MODULAR BETTER FOR MY USECASE I GUESS

resource "aws_subnet" "public" {
  count = var.create_public_subnets ? local.len_public_subnets : 0

  vpc_id                  = aws_vpc.this[0].id
  region                  = var.region
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch = var.map_public_ip_on_launch
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)

  tags = merge(
    { "Name" = format("%s-public-subnet-%s", var.name_prefix, split("-", var.azs[count.index])[2]) },
    var.tags
  )
}

resource "aws_route_table" "public" {
  count = var.create_public_subnets ? local.len_public_subnets : 0

  vpc_id = aws_vpc.this[0].id
  region = var.region

  tags = merge(
    { "Name" = format("%s-public-subnet-rt-%s", var.name_prefix, split("-", var.azs[count.index])[2]) },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count = var.create_public_subnets ? local.len_public_subnets : 0

  region = var.region

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, count.index)
}

resource "aws_route" "public_internet_gateway" {
  count = var.create_public_subnets && var.create_igw ? local.len_public_subnets : 0

  region = var.region

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_internet_gateway" "this" {
  count = var.create_public_subnets && var.create_igw ? 1 : 0

  region = var.region

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    { "Name" = format("%s-igw", var.name_prefix) },
    var.tags,
  )
}

resource "aws_eip" "nat" {
  count = var.create_vpc && var.enable_nat_gateway ? local.len_public_subnets : 0

  region = var.region

  domain = "vpc"

  tags = merge(
    { "Name" = format("%s-nat-eip-%s", var.name_prefix, split("-", var.azs[count.index])[2]) },
    var.tags,
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count = var.create_vpc && var.enable_nat_gateway ? local.len_public_subnets : 0

  region = var.region

  allocation_id = element(local.nat_gateway_ips, count.index)
  subnet_id     = element(aws_subnet.public[*].id, count.index)

  tags = merge(
    {
      "Name" = format(
        "%s-nat-gw-%s",
        var.name_prefix,
        split("-", element(var.azs, count.index))[2],
      )
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_subnet" "private" {
  count = var.create_private_subnets ? local.len_private_subnets : 0

  vpc_id               = aws_vpc.this[0].id
  region               = var.region
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  cidr_block           = element(concat(var.private_subnets, [""]), count.index)

  tags = merge(
    { "Name" = format("%s-private-subnet-%s", var.name_prefix, split("-", var.azs[count.index])[2]) },
    var.tags
  )
}

resource "aws_route_table" "private" {
  count = var.create_private_subnets ? local.len_private_subnets : 0

  vpc_id = aws_vpc.this[0].id
  region = var.region

  tags = merge(
    { "Name" = format("%s-private-subnet-rt-%s", var.name_prefix, split("-", var.azs[count.index])[2]) },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count = var.create_private_subnets ? local.len_private_subnets : 0

  region = var.region

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

resource "aws_route" "private_nat_gateway" {
  count = var.create_private_subnets && var.enable_nat_gateway ? local.len_private_subnets : 0

  region = var.region

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}
