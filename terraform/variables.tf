# AWS Region
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

# S3 Bucket for Terraform State
variable "s3_bucket" {
  description = "Name of the S3 bucket to store Terraform state"
  type        = string
}

# S3 Region for Terraform State
variable "s3_region" {
  description = "AWS region of the S3 bucket to store Terraform state"
  type        = string
}

# EKS Cluster Name
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "game-2048-cluster"
}

# VPC ID
variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

# Subnet IDs
variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

# Node Group Configuration
variable "desired_capacity" {
  description = "Desired number of worker nodes in the EKS cluster"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of worker nodes in the EKS cluster"
  type        = number
  default     = 3
}

variable "min_capacity" {
  description = "Minimum number of worker nodes in the EKS cluster"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Instance type for the EKS worker nodes"
  type        = string
  default     = "t2.medium"
}
