output "cluster_role_arn" {
  description = "EKS control-plane IAM role ARN."
  value       = aws_iam_role.cluster.arn
}

output "node_role_arn" {
  description = "Managed worker node IAM role ARN."
  value       = aws_iam_role.node.arn
}

output "ebs_csi_role_arn" {
  description = "EBS CSI add-on Pod Identity role ARN, or null when disabled."
  value       = var.enable_ebs_csi_driver ? aws_iam_role.ebs_csi[0].arn : null
}