variable "s3_bucket" {
  description = "S3 bucket name for storing the Terraform state"
  type        = string
  default     = "my-eks-cluster-terraform-state-dev"
}

variable "s3_region" {
  description = "Region of the S3 bucket"
  type        = string
  default     = "us-east-1"
}

variable "dynamodb_table" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
  default     = "my-eks-cluster-terraform-lock-dev"
}
