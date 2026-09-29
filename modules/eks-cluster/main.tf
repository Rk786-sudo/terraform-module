resource "aws_eks_cluster" "this" {
  name     = var.name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  enabled_cluster_log_types = var.control_plane_log_types

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [var.cluster_security_group_id]
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.endpoint_public_access ? var.public_access_cidrs : null
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition     = length(var.private_subnet_ids) >= 2
      error_message = "EKS requires private subnets in at least two Availability Zones."
    }
    precondition {
      condition     = !var.endpoint_public_access || length(var.public_access_cidrs) > 0
      error_message = "Public EKS endpoint access requires at least one trusted public_access_cidrs entry."
    }
  }
}