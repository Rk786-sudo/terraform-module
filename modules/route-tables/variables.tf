variable "name" {
  description = "Name prefix for route tables."
  type        = string
}

variable "vpc_id" {
  description = "VPC containing the route tables."
  type        = string
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID for the public default route."
  type        = string
}

variable "nat_gateway_ids" {
  description = "NAT Gateway IDs used for private-subnet default routes."
  type        = list(string)
  default     = []
}

variable "public_subnet_ids" {
  description = "Public subnets to associate with the public route table."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnets to associate with private route tables."
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "When true, all private subnets use the first NAT Gateway."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to route tables."
  type        = map(string)
  default     = {}
}