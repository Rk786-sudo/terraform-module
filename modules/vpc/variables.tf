variable "name" {
  description = "Name prefix for VPC resources."
  type        = string
}

variable "cidr_block" {
  description = "VPC IPv4 CIDR block."
  type        = string
}

variable "tags" {
  description = "Tags applied to VPC resources."
  type        = map(string)
  default     = {}
}