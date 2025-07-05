# Terraform AWS Networking + EKS Module

This Terraform project provisions foundational AWS infrastructure and an Amazon EKS cluster using production-ready best practices. It supports workloads such as containerized apps, microservices, and internal tools running in Kubernetes.

## Features

- VPC with DNS support
- Public and private subnets
- Internet Gateway (IGW) and NAT Gateway
- Route tables and associations
- Default security group with SSH access
- EKS control plane and managed node group
- IAM roles and policies for EKS components
- Parameterized configuration and clean outputs
- Remote state backend configuration (commented out for dry-run)

## Inputs

| Variable              | Description                          | Example            |
|-----------------------|--------------------------------------|--------------------|
| `aws_region`          | AWS region                           | `il-central-1`     |
| `vpc_cidr`            | CIDR for VPC                         | `10.0.0.0/16`      |
| `public_subnet_cidr`  | CIDR for public subnet               | `10.0.1.0/24`      |
| `private_subnet_cidr` | CIDR for private subnet              | `10.0.2.0/24`      |
| `availability_zone`   | Availability Zone                   | `il-central-1a`    |
| `cluster_name`        | Name of the EKS cluster              | `dev-cluster`      |
| `kubernetes_version`  | Version of Kubernetes for the cluster| `1.29`             |

## Outputs

- VPC ID
- Public and private subnet IDs
- Security Group ID
- EKS Cluster Name and API Endpoint

## Usage

Initialize and dry-run:

```bash
terraform init
terraform plan
```

## Remote State

`backend.tf` is configured for S3 + optional locking, but commented out to allow local dry-run and demonstration. To use remote state:

1. Create an S3 bucket in the desired region
2. Uncomment `backend.tf`
3. Run `terraform init` again

## License

This project is open-source and intended for portfolio demonstrations and practical DevOps infrastructure scenarios.
