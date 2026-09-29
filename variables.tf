variable "aws_region" {
  description = "AWS region in which to create the EKS environment."
  type        = string
}

variable "aws_profile" {
  description = "Optional local AWS CLI profile name. Leave null to use the standard AWS credential chain."
  type        = string
  default     = null
  nullable    = true
}

variable "cluster_name" {
  description = "Name used for the EKS cluster and related resources."
  type        = string
  default     = "eks-platform"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes minor version supported in the selected region."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.20.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "At least two Availability Zones in the selected region, in subnet-CIDR order."
  type        = list(string)
  validation {
    condition = length(var.availability_zones) >= 2 &&
      length(distinct(var.availability_zones)) == length(var.availability_zones) &&
      length(var.public_subnet_cidrs) == length(var.availability_zones) &&
      length(var.private_subnet_cidrs) == length(var.availability_zones)
    error_message = "Specify at least two distinct Availability Zones and one public and private subnet CIDR for each AZ."
  }
}

variable "public_subnet_cidrs" {
  description = "One public subnet CIDR per Availability Zone."
  type        = list(string)
  default     = ["10.20.0.0/20", "10.20.16.0/20"]
  validation {
    condition     = alltrue([for cidr in var.public_subnet_cidrs : can(cidrnetmask(cidr))])
    error_message = "Every public subnet CIDR must be a valid IPv4 CIDR block."
  }
}

variable "private_subnet_cidrs" {
  description = "One private subnet CIDR per Availability Zone."
  type        = list(string)
  default     = ["10.20.32.0/20", "10.20.48.0/20"]
  validation {
    condition     = alltrue([for cidr in var.private_subnet_cidrs : can(cidrnetmask(cidr))])
    error_message = "Every private subnet CIDR must be a valid IPv4 CIDR block."
  }
}

variable "worker_instance_type" {
  description = "EC2 instance type for EKS managed worker nodes. Must be selected before deployment."
  type        = string
}

variable "desired_worker_count" {
  description = "Desired number of managed worker nodes."
  type        = number
  default     = 2
  validation {
    condition     = var.desired_worker_count >= 1 && floor(var.desired_worker_count) == var.desired_worker_count
    error_message = "desired_worker_count must be a positive integer."
  }
}

variable "minimum_worker_count" {
  description = "Minimum number of managed worker nodes."
  type        = number
  default     = 1
  validation {
    condition     = var.minimum_worker_count >= 1 && floor(var.minimum_worker_count) == var.minimum_worker_count
    error_message = "minimum_worker_count must be a positive integer."
  }
}

variable "maximum_worker_count" {
  description = "Maximum number of managed worker nodes."
  type        = number
  default     = 4
  validation {
    condition     = var.maximum_worker_count >= 1 && floor(var.maximum_worker_count) == var.maximum_worker_count
    error_message = "maximum_worker_count must be a positive integer."
  }
}

variable "worker_disk_size" {
  description = "Worker root volume size in GiB."
  type        = number
  default     = 50
  validation {
    condition     = var.worker_disk_size >= 20 && floor(var.worker_disk_size) == var.worker_disk_size
    error_message = "worker_disk_size must be an integer of at least 20 GiB."
  }
}

variable "node_group_name" {
  description = "Name of the EKS managed node group."
  type        = string
  default     = "private-workers"
}

variable "worker_ami_type" {
  description = "EKS managed node group AMI family."
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "ssh_key_pair_name" {
  description = "Optional EC2 key pair name for managed node SSH access. SSH remains disabled unless trusted SSH CIDRs are also supplied."
  type        = string
  default     = null
  nullable    = true
}

variable "ssh_trusted_cidrs" {
  description = "Trusted IPv4 CIDRs allowed to SSH to worker nodes when an SSH key is configured. Prefer a bastion or SSM instead."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for cidr in var.ssh_trusted_cidrs : can(cidrnetmask(cidr))])
    error_message = "Every SSH trusted CIDR must be a valid IPv4 CIDR block."
  }
}

variable "eks_endpoint_access" {
  description = "EKS API endpoint access mode: private, public, or both."
  type        = string
  default     = "private"
  validation {
    condition     = contains(["private", "public", "both"], var.eks_endpoint_access)
    error_message = "eks_endpoint_access must be private, public, or both."
  }
}

variable "eks_public_access_cidrs" {
  description = "Trusted IPv4 CIDRs for the public EKS API endpoint; required when public endpoint access is enabled."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for cidr in var.eks_public_access_cidrs : can(cidrnetmask(cidr))])
    error_message = "Every EKS public access CIDR must be a valid IPv4 CIDR block."
  }
}

variable "eks_admin_access_cidrs" {
  description = "Optional trusted IPv4 CIDRs allowed to reach the private EKS API endpoint through the cluster security group."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for cidr in var.eks_admin_access_cidrs : can(cidrnetmask(cidr))])
    error_message = "Every EKS administrator access CIDR must be a valid IPv4 CIDR block."
  }
}

variable "control_plane_log_types" {
  description = "EKS control-plane log types to publish to CloudWatch Logs."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "nat_gateway_enabled" {
  description = "Whether to create NAT Gateway resources for private-subnet outbound internet access."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use one shared NAT Gateway (lower cost) instead of one NAT Gateway per AZ."
  type        = bool
  default     = true
}

variable "enable_ebs_csi_driver" {
  description = "Whether to install the EKS EBS CSI managed add-on and its Pod Identity permissions."
  type        = bool
  default     = true
}

variable "resource_tags" {
  description = "Tags applied to resources created by this project."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "eks-platform"
  }
}

variable "public_nacl_ingress_rules" {
  description = "Optional public subnet NACL ingress rules. Defaults permit HTTP/HTTPS and ephemeral return traffic."
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    from_port   = number
    to_port     = number
    cidr_block  = string
  }))
  default = null
  nullable = true
}

variable "public_nacl_egress_rules" {
  description = "Optional public subnet NACL egress rules. Defaults permit outbound IPv4 traffic."
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    from_port   = number
    to_port     = number
    cidr_block  = string
  }))
  default = null
  nullable = true
}

variable "private_nacl_ingress_rules" {
  description = "Optional private subnet NACL ingress rules. Defaults permit VPC traffic and ephemeral return traffic."
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    from_port   = number
    to_port     = number
    cidr_block  = string
  }))
  default = null
  nullable = true
}

variable "private_nacl_egress_rules" {
  description = "Optional private subnet NACL egress rules. Defaults permit VPC and outbound IPv4 traffic."
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    from_port   = number
    to_port     = number
    cidr_block  = string
  }))
  default = null
  nullable = true
}