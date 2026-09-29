variable "name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes minor version."
  type        = string
}

variable "cluster_role_arn" {
  description = "IAM role ARN assumed by the AWS-managed EKS control plane."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private VPC subnet IDs for EKS control-plane ENIs."
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "Additional security group attached to EKS control-plane ENIs."
  type        = string
}

variable "endpoint_private_access" {
  description = "Enable the private EKS API endpoint."
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable the public EKS API endpoint."
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "Trusted IPv4 CIDRs for public Kubernetes API access."
  type        = list(string)
  default     = []
}

variable "control_plane_log_types" {
  description = "EKS control-plane log types enabled in CloudWatch Logs."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "tags" {
  description = "Tags applied to the EKS cluster."
  type        = map(string)
  default     = {}
}