variable "aws_region" {
  description = "the region"
  type= string
}


variable "vpc_cidr" {
  description = "The VPC cidr range"
  type        = string
}


variable "public_subnet_cidr" {
  description = "The public subnet cidr"
  type        = string
}

variable "availability_zone1" {
  description = "The availability zone"
  type        = string
}

variable "availability_zone2" {
  description = "The availability zone"
  type        = string
}


variable "private_subnet_cidr" {
  description = "The private subnet cidr"
  type        = string
}

variable "ec2_instances" {
  type = map(object({
    ami = string
    instance_type = string
  }))
}