module "eks" {
  source             = "terraform-aws-modules/eks/aws"
  version            = "21.0.0"
  name               = "Asafcluster"
  kubernetes_version = "1.33"
  vpc_id             = aws_vpc.asaf_vpc.id
  subnet_ids         = [aws_subnet.private_subnet.id, aws_subnet.public_subnet.id]
 

eks_managed_node_groups = {
    default = {
      min_size     = 2
      max_size     = 5
      desired_size = 2
    }
  }
 tags = { 
    Name = "Asafcluster"
    ENV = "Dev"
    }

}