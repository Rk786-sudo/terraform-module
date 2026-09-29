output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint URL."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_arn" {
  description = "EKS cluster ARN."
  value       = aws_eks_cluster.this.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded cluster certificate authority data."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  description = "Cluster OIDC issuer URL for future IRSA integrations."
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}