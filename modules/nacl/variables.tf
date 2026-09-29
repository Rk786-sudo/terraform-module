variable "name" {
  description = "Name prefix for network ACLs."
  type        = string
}

variable "vpc_id" {
  description = "VPC in which to create the network ACLs."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR used by default internal traffic rules."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs associated with the public ACL."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs associated with the private ACL."
  type        = list(string)
}

variable "public_ingress_rules" {
  description = "Public ACL ingress entries. Null selects the documented HTTP, HTTPS, and ephemeral defaults."
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    from_port   = number
    to_port     = number
    cidr_block  = string
  }))
  default  = null
  nullable = true
}

variable "public_egress_rules" {
  description = "Public ACL egress entries. Null selects an allow-all IPv4 default."
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    from_port   = number
    to_port     = number
    cidr_block  = string
  }))
  default  = null
  nullable = true
}

variable "private_ingress_rules" {
  description = "Private ACL ingress entries. Null selects VPC traffic and ephemeral return traffic."
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    from_port   = number
    to_port     = number
    cidr_block  = string
  }))
  default  = null
  nullable = true
}

variable "private_egress_rules" {
  description = "Private ACL egress entries. Null selects VPC and outbound IPv4 defaults."
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    from_port   = number
    to_port     = number
    cidr_block  = string
  }))
  default  = null
  nullable = true
}

variable "tags" {
  description = "Tags applied to network ACLs."
  type        = map(string)
  default     = {}
}