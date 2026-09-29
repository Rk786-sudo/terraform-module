variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "node_group_name" {
  description = "Managed node group name."
  type        = string
}

variable "node_role_arn" {
  description = "Worker node IAM role ARN."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs in which to place worker nodes."
  type        = list(string)
}

variable "node_security_group_id" {
  description = "Dedicated worker security group to attach through the launch template."
  type        = string
}

variable "admin_security_group_id" {
  description = "Source security group for optional managed-node SSH access."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type used by the managed node group."
  type        = string
}

variable "desired_size" {
  description = "Desired managed node count."
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum managed node count."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum managed node count."
  type        = number
  default     = 4
}

variable "disk_size" {
  description = "Worker root volume size in GiB."
  type        = number
  default     = 50
}

variable "ami_type" {
  description = "EKS managed node group AMI family."
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "ssh_key_pair_name" {
  description = "Existing EC2 key pair for optional SSH access."
  type        = string
  default     = null
  nullable    = true
}

variable "ssh_enabled" {
  description = "Whether optional SSH access has been explicitly configured."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to node group and launch template instances/volumes."
  type        = map(string)
  default     = {}
}