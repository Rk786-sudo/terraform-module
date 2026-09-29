variable "name" {
  description = "Name prefix for NAT Gateway resources."
  type        = string
}

variable "enabled" {
  description = "Whether NAT Gateways and their Elastic IPs are created."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Create one shared NAT Gateway instead of one per public subnet."
  type        = bool
  default     = true
}

variable "public_subnet_ids" {
  description = "Public subnet IDs; NAT Gateways are placed in these subnets."
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to NAT Gateway resources."
  type        = map(string)
  default     = {}
}