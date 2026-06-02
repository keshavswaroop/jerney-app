# VPC
# ├── Public Subnets
# ├── Private Subnets
# ├── Internet Gateway
# ├── NAT Gateway
# ├── Route Tables

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr_range

  azs             = var.vpc_az
  private_subnets = var.vpc_private_subnet
  public_subnets  = var.vpc_public_subnet

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = var.tag_environment
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"                        = 1
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"               = 1
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}


# EKS Cluster
# ├── Managed Nodegroup
# ├── IAM Roles
# ├── Security Groups


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = "1.32"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }

    vpc-cni = {
      most_recent = true
    }

    aws-ebs-csi-driver = {
      most_recent = true
    }
  }


  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  #oidc
  #   terraform automatically creates OIDC provider
  enable_irsa = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    default = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      #   ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = [var.eks_nodegroup_instance_type]

      min_size     = var.eks_nodegroup_min_size
      max_size     = var.eks_nodegroup_max_size
      desired_size = var.eks_nodegroup_desired_size

      capacity_type = "ON_DEMAND"

      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }


    }
  }

  tags = {
    Environment = var.tag_environment
    Terraform   = "true"
  }
}


# We want terraform to manage -
# OIDC Provider 
# IAM role 
# TAM policy attachment 
# vpc 
# eks 
