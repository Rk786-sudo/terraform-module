output "public_network_acl_id" {
  description = "Public subnet network ACL ID."
  value       = aws_network_acl.public.id
}

output "private_network_acl_id" {
  description = "Private subnet network ACL ID."
  value       = aws_network_acl.private.id
}