output "vpc_id" {
  description = "The ID of the VPC"
  value       = one(aws_vpc.this[*].id)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = one(aws_vpc.this[*].cidr_block)
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "List of CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_ids" {
  description = "List of IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_cidrs" {
  description = "List of CIDR blocks of the private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "public_route_table_ids" {
  description = "List of IDs of the public route tables"
  value       = aws_route_table.public[*].id
}

output "private_route_table_ids" {
  description = "List of IDs of the private route tables"
  value       = aws_route_table.private[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = one(aws_internet_gateway.this[*].id)
}

output "nat_gateway_ids" {
  description = "List of IDs of the NAT gateways"
  value       = aws_nat_gateway.this[*].id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs assigned to the NAT gateways"
  value       = aws_eip.nat[*].public_ip
}
