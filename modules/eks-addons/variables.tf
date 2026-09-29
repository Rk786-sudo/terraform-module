variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version used by the cluster; kept as an input for caller compatibility and documentation."
  type        = string
}

variable "enable_ebs_csi_driver" {
  description = "Install the EBS CSI driver and the Pod Identity agent."
  type        = bool
  default     = true
}

variable "ebs_csi_role_arn" {
  description = "Pod Identity role ARN for the EBS CSI driver when enabled."
  type        = string
  default     = null
  nullable    = true
}

variable "addon_versions" {
  description = "Optional explicit versions keyed by EKS add-on name. Unspecified add-ons use the newest compatible version."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags applied to managed add-ons."
  type        = map(string)
  default     = {}
}