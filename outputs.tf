output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets used by EKS and worker nodes."
  value       = module.subnets.private_subnet_ids
}

output "eks_cluster_name" {
  description = "EKS cluster name."
  value       = module.eks_cluster.cluster_name
}

output "eks_cluster_arn" {
  description = "EKS cluster ARN."
  value       = module.eks_cluster.cluster_arn
}

output "eks_cluster_endpoint" {
  description = "EKS Kubernetes API endpoint."
  value       = module.eks_cluster.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64-encoded cluster certificate authority data."
  value       = module.eks_cluster.cluster_certificate_authority_data
  sensitive   = true
}

output "node_group_name" {
  description = "EKS managed node group name."
  value       = module.eks_nodegroup.node_group_name
}