#########.  VPC Module for Terraform ######### 
# This module creates a VPC with public subnets in AWS.
# It is designed to be reusable and configurable through variables.

######  VPC Configuration  ######
resource "aws_vpc" "main" {        # Creates a new VPC with the given CIDR     
  cidr_block = var.cidr_block
  enable_dns_support = true        # Enable DNS Support and hostnames
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {   # Tags the VPC using a combination of common_tags and a custom name
    Name = "${var.environment}-vpc"
  })   
}

######  Public Subnets Configuration  ######
# This section creates public subnets based on the provided CIDR blocks and availability zones.
# The number of public subnets is determined by the length of the public_subnet_cidr variable.
resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidr)              #  Creates one public subnet per cidr provided
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = var.availability_zones[count.index] # Distributes them across AZs
    map_public_ip_on_launch = true                          # Enables auto-assignment of public IPs 

    tags = merge(var.common_tags, {
        Name = "${var.environment}-public-subnet-${count.index + 1}"
    })
  
}

###### Private Subnets Configuration ######
# This section creates private subnets based on the provided CIDR blocks and availability zones.
resource "aws_subnet" "private" {               # Create private subnets 
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr[count.index]       # Each subnet goes into a different AZ for high availability
    availability_zone = var.availability_zones[count.index]

    tags = merge(var.common_tags, {
        Name = "${var.environment}-private-subnet-${count.index + 1}"
    })
}

######  Internet Gateway Configuration  ######
# This section creates an Internet Gateway and attaches it to the VPC.
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = merge(var.common_tags, {
        Name = "${var.environment}-igw"
    })
}

###### Elastic IP Configuration ######
# This section allocates an Elastic IP address for the NAT Gateway.
resource "aws_eip" "nat" {
    count = var.enable_nat_gateway ? length(var.availability_zones) : 0
    domain = "vpc"  # Specifies that the EIP is for a VPC

    tags = merge(var.common_tags, {
        Name = "${var.environment}-nat-eip-${count.index +1}"
    })
}

###### NAT Gateway Configuration ######
# This section creates a NAT Gateway in each public subnet to allow private subnets to access the internet.
resource "aws_nat_gateway" "main" {
    count = var.enable_nat_gateway ? length(var.availability_zones) : 0
    allocation_id = aws_eip.nat[count.index].id
    subnet_id = aws_subnet.public[count.index].id

    tags = merge(var.common_tags, {
        Name = "${var.environment}-nat-gateway-${count.index + 1}"
    })
}

###### Route Table Configuration ######
# This section creates a route table for the public subnets and associates it with them.
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route{
        cidr_block = "0.0.0.0/0"  # Route all traffic to the internet
        gateway_id = aws_internet_gateway.main.id
    }

    tags = merge(var.common_tags, {
        Name = "${var.environment}-public-rt"
    })
}

# This section creates a route table for the private subnets and associates it with them.
resource "aws_route_table" "private" {
    count = var.enable_nat_gateway ? length(var.private_subnet_cidr) : 0
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"  # Route all traffic to the NAT Gateway
        nat_gateway_id = aws_nat_gateway.main[count.index].id

    }

    tags = merge(var.common_tags, {
        Name = "${var.environment}-private-rt-${count.index + 1}"
    })
}

###### Route Table Associations ######
# This section associates the public route table with the public subnets.
resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidr)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

# This section associates the private route table with the private subnets.
resource "aws_route_table_association" "private" {
    count = var.enable_nat_gateway ? length(var.private_subnet_cidr) : 0
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private[count.index].id
}

##### VPC endpoints Configuration ######
# This section creates VPC endpoints for S3
#resource "aws_vpc_endpoint" "s3" {
#    count = var.enable_s3_endpoint ? 1 : 0
#    vpc_id = aws_vpc.main.id
#    service_name = "com.amazonaws.${var.region}.s3"
#    route_table_ids = [for rt in aws_route_table.private[*] : rt.id]
#    vpc_endpoint_type = "Gateway"  # S3 endpoint type is Gateway

#    tags = merge(var.common_tags, {
#        Name = "${var.environment}-s3-endpoint"
#    })
#}