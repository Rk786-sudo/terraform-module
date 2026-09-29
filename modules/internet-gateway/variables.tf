variable "name" {
  description = "Name prefix for the Internet Gateway."
  type        = string
}

variable "vpc_id" {
  description = "VPC to attach to the Internet Gateway."
  type        = string
}

variable "tags" {
  description = "Tags applied to the Internet Gateway."
  type        = map(string)
  default     = {}
}