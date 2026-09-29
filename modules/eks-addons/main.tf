locals {
  addons = merge(
    {
      "vpc-cni"    = true
      "coredns"    = true
      "kube-proxy" = true
    },
    var.enable_ebs_csi_driver ? {
      "eks-pod-identity-agent" = true
      "aws-ebs-csi-driver"     = true
    } : {}
  )
}

resource "aws_eks_addon" "this" {
  for_each = local.addons

  cluster_name                = var.cluster_name
  addon_name                  = each.key
  addon_version               = lookup(var.addon_versions, each.key, null)
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
  preserve                    = true
  tags                        = var.tags

  most_recent = lookup(var.addon_versions, each.key, null) == null

  dynamic "pod_identity_association" {
    for_each = each.key == "aws-ebs-csi-driver" && var.enable_ebs_csi_driver ? [1] : []
    content {
      role_arn        = var.ebs_csi_role_arn
      service_account = "ebs-csi-controller-sa"
    }
  }
}