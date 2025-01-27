provider "aws" {
  region = var.region
}

# S3 Backend for Terraform State
terraform {
  backend "s3" {
    bucket         = var.s3_bucket
    key            = "eks/terraform.tfstate"
    region         = var.s3_region
    encrypt        = true
    dynamodb_table = var.dynamodb_table
  }
}

# Create EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  subnets         = var.subnet_ids
  vpc_id          = var.vpc_id
  node_groups = {
    default = {
      desired_capacity = var.desired_capacity
      max_capacity     = var.max_capacity
      min_capacity     = var.min_capacity
      instance_type    = var.instance_type
    }
  }
  manage_aws_auth = true
}

# IAM Role for EKS
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "eks.amazonaws.com" }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Output for kubectl
output "kubeconfig" {
  value = module.eks.kubeconfig
  sensitive = true
}
