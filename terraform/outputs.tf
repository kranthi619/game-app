# Outputs for EKS Cluster
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "The security group ID for the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "node_group_arns" {
  description = "ARNs of the node groups created for the EKS cluster"
  value       = module.eks.node_groups_arn
}

output "node_group_names" {
  description = "Names of the node groups created for the EKS cluster"
  value       = module.eks.node_groups
}
