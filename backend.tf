terraform {
  backend "s3" {
    bucket         = "devops-terraform-state5454"
    key            = "eks/network/terraform.tfstate"
    region         = "il-central-1"
    encrypt        = true
    use_lockfile   = true
  }
}
