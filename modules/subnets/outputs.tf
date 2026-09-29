output "public_subnet_ids" {
  description = "Public subnet IDs, ordered by the supplied Availability Zones."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs, ordered by the supplied Availability Zones."
  value       = aws_subnet.private[*].id
}