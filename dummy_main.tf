provider "aws" {
  region = "us-east-1"
}

resource "aws_eks_cluster" "game_cluster" {
  name     = "game-2048-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_subnets[*].id
  }
}

resource "aws_eks_fargate_profile" "game_fargate" {
  cluster_name           = aws_eks_cluster.game_cluster.name
  fargate_profile_name   = "game-2048"
  pod_execution_role_arn = aws_iam_role.eks_pod_execution_role.arn

  subnet_ids = aws_subnet.eks_subnets[*].id

  selector {
    namespace = "default"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "eks-vpc"

  cidr           = "10.0.0.0/16"
  azs            = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
}

resource "aws_subnet" "eks_subnets" {
  for_each = toset(["us-east-1a", "us-east-1b"])
  vpc_id   = module.vpc.vpc_id
  cidr_block = cidrsubnet(
    module.vpc.cidr,
    8,
    index(["us-east-1a", "us-east-1b"], index(["us-east-1a", "us-east-1b"], each.value))
  )
  availability_zone = each.value
}

resource "aws_iam_role" "eks_role" {
  name               = "eks-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
}

resource "aws_iam_role" "eks_pod_execution_role" {
  name               = "eks-pod-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks-fargate-pods.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  ]
}
