# Terraform AWS Networking and EKS Cluster

This repository contains Terraform code that provisions AWS network infrastructure and an Amazon EKS (Elastic Kubernetes Service) cluster in a production-style configuration. It is designed for demonstration, development, and DevOps interview purposes.

## Overview

This project creates:

- A VPC with DNS support
- Public and private subnets in a single Availability Zone
- Internet Gateway and NAT Gateway
- Route tables for public and private subnets
- A default security group
- An EKS cluster using the official `terraform-aws-eks` module
- Managed node group for worker nodes
- IAM roles for EKS control plane and nodes
- Remote backend support via S3 (commented out by default)

## File Structure

```
terraform-aws-networking/
├── backend.tf           # Remote state backend config (commented for dry-run)
├── eks.tf               # EKS module and IAM roles
├── main.tf              # VPC, subnets, NAT, IGW, security group
├── outputs.tf           # Terraform outputs
├── provider.tf          # AWS provider
├── terraform.tfvars     # Input variable values
├── variables.tf         # Input variable definitions
├── .gitignore
└── README.md
```

## Inputs

The following input variables are used to configure the infrastructure:

| Variable              | Description                              | Example           |
|-----------------------|------------------------------------------|-------------------|
| `aws_region`          | AWS region for deployment                | `il-central-1`    |
| `vpc_cidr`            | CIDR block for the VPC                   | `10.0.0.0/16`     |
| `public_subnet_cidr`  | CIDR block for the public subnet         | `10.0.1.0/24`     |
| `private_subnet_cidr` | CIDR block for the private subnet        | `10.0.2.0/24`     |
| `availability_zone`   | Availability zone for the subnets        | `il-central-1a`   |
| `cluster_name`        | Name of the EKS cluster                  | `eks-dev`         |
| `kubernetes_version`  | Kubernetes version to deploy             | `1.29`            |
| `environment`         | Environment label for tags (e.g. dev)    | `dev`             |

## Outputs

| Output Name              | Description                               |
|--------------------------|-------------------------------------------|
| `vpc_id`                 | The ID of the provisioned VPC             |
| `public_subnet_id`       | The ID of the public subnet               |
| `private_subnet_id`      | The ID of the private subnet              |
| `security_group_id`      | The ID of the default security group      |
| `eks_cluster_id`         | The name of the EKS cluster               |
| `eks_cluster_endpoint`   | The Kubernetes API server endpoint        |
| `eks_node_group_role_arn`| The IAM role ARN for the worker nodes     |

## Usage

Initialize Terraform and review the execution plan:

```bash
terraform init
terraform plan
```

To apply and create the infrastructure:

```bash
terraform apply
```



## Backend Configuration (Optional)

If you want to use remote backend, create the following:

- S3 bucket (e.g. `devops-terraform-state`) in `il-central-1`
- Optional: enable versioning and encryption

## Tools and Modules Used

- Terraform (≥ v1.5.0)
- [terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks) module
- AWS provider

## License

This project is for  professional demonstration,. You are free to adapt it for your own use.
