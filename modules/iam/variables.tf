variable "name" {
  description = "Name prefix for IAM roles."
  type        = string
}

variable "enable_ebs_csi_driver" {
  description = "Create the Pod Identity role required by the optional EBS CSI add-on."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to IAM roles."
  type        = map(string)
  default     = {}
}