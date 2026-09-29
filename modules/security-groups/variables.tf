variable "name" {
  description = "Name prefix for security groups."
  type        = string
}

variable "vpc_id" {
  description = "VPC in which to create the security groups."
  type        = string
}

variable "eks_public_access_cidrs" {
  description = "Trusted CIDRs allowed to reach the EKS API through the control-plane security group."
  type        = list(string)
  default     = []
}

variable "eks_admin_access_cidrs" {
  description = "Trusted CIDRs allowed to reach the Kubernetes API through the private control-plane network path."
  type        = list(string)
  default     = []
}

variable "ssh_enabled" {
  description = "Whether optional SSH ingress and source rules are created."
  type        = bool
  default     = false
}

variable "ssh_trusted_cidrs" {
  description = "Trusted CIDRs allowed as the source for optional SSH access."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to security groups."
  type        = map(string)
  default     = {}
}