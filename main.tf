#creating VPC
resource "aws_vpc" "asaf_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "eks-vpc"
  }

}

locals {
  subnet_map = {
     "Asafpublic1" = aws_subnet.public_subnet.id
     "Asafpublic2" = aws_subnet.private_subnet.id
     "Asafpublic3" = aws_subnet.private_subnet.id
       }
}

#creating public subnet

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.asaf_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone1
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public-subnet"
  }
}

#creating private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.asaf_vpc.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = false #not needed because by default it is false

  tags = {
    Name = "eks-private-subnet"
  }
}

#internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.asaf_vpc.id
  tags = {
    Name = "eks-igw"
  }

}

# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id =  aws_eip.nat.id
#   subnet_id=aws_subnet.public_subnet.id
#   depends_on=  [ aws_internet_gateway.igw ]
#   tags = {
#     Name = "eks-nat-gateway"
#   }
# }

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.asaf_vpc.id
  tags   = { Name = "eks-public-route" }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.asaf_vpc.id
#   tags = { Name = "eks-private-route"}
# }

# resource aws_route "private_route"  {
#   route_table_id = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id = aws_nat_gateway.nat.id
# }


# resource "aws_route_table_association" "private_assoc" {
#   subnet_id = aws_subnet.private_subnet.id
#   route_table_id = aws_route_table.private.id
# }

resource "aws_security_group" "default_sg" {
  name        = "default_sg"
  vpc_id      = aws_vpc.asaf_vpc.id
  description = "allow ssh inbout and all egress"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "eks-default-sg"
  }
}


# resource "aws_instance" "private_instance" {
#   count             = 2
#   ami               = "ami-043d0a4dfadf44f5b"
#   instance_type     = "t3.micro"
#   availability_zone = "il-central-1a"
#   subnet_id         = aws_subnet.private_subnet.id
#   key_name          = "DemoKeyPair"
#   tags              = { Name = "Asaf private ec2 instance #${count.index}" }
#   security_groups   = [aws_security_group.default_sg.id]
# }



# resource "aws_instance" "public_instance" {
#   count             = 3
#   ami               = "ami-043d0a4dfadf44f5b"
#   instance_type     = "t3.micro"
#   availability_zone = "il-central-1a"
#   subnet_id         = aws_subnet.public_subnet.id
#   key_name          = "DemoKeyPair"
#   tags              = { Name = "Asaf public ec2 instance #${count.index}" }
#   security_groups   = [aws_security_group.default_sg.id]
# }

# resource "aws_instance" "public_instance" {
#   for_each          = toset(["Asafpublic1", "Asafpublic2"])
#   instance_type     = "t3.micro"
#   availability_zone = "il-central-1a"
#   ami               = "ami-043d0a4dfadf44f5b"
#   subnet_id         = aws_subnet.public_subnet.id
#   key_name          = "DemoKeyPair"
#   tags              = { Name = each.key }
# }


resource "aws_instance" "public_instance" {
  for_each          = var.ec2_instances
  instance_type     = each.value.instance_type
  availability_zone = "il-central-1a"
  ami               = each.value.ami
  subnet_id         = local.subnet_map[each.key]
  key_name          = "DemoKeyPair"
  tags              = { Name = each.key }
}


output "instance_ids_by_name" {
  value = {
    for k,v in aws_instance.public_instance : k => v.id
  }
}

