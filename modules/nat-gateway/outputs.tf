output "nat_gateway_ids" {
  description = "NAT Gateway IDs, empty when NAT is disabled."
  value       = aws_nat_gateway.this[*].id
}

output "nat_gateway_public_ips" {
  description = "Public Elastic IPs associated with NAT Gateways."
  value       = aws_eip.this[*].public_ip
}