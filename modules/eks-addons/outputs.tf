output "addon_arns" {
  description = "ARNs of the managed EKS add-ons."
  value       = { for name, addon in aws_eks_addon.this : name => addon.arn }
}

output "addon_versions" {
  description = "Resolved versions of the managed EKS add-ons."
  value       = { for name, addon in aws_eks_addon.this : name => addon.addon_version }
}