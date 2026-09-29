output "cluster_security_group_id" {
  description = "Additional EKS control-plane security group ID."
  value       = aws_security_group.cluster.id
}

output "worker_security_group_id" {
  description = "Managed worker node security group ID."
  value       = aws_security_group.workers.id
}

output "admin_security_group_id" {
  description = "Optional administrator source security group ID."
  value       = aws_security_group.admin.id
}