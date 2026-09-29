variable "name" {
  description = "Name prefix for subnet resources and EKS discovery tags."
  type        = string
}

variable "vpc_id" {
  description = "VPC in which to create the subnets."
  type        = string
}

variable "availability_zones" {
  description = "Availability Zone for each public/private CIDR entry."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs, one per Availability Zone."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs, one per Availability Zone."
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to subnet resources."
  type        = map(string)
  default     = {}
}