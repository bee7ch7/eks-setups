# output "vpc_endpoint_id" {
#   #   value = { for k, v in aws_vpc_endpoint.this : k => v.id }
#   value = aws_vpc_endpoint.this.id
# }

output "endpoints" {
  description = "Array containing the full resource object and attributes for all endpoints created"
  value       = { for k, v in aws_vpc_endpoint.this : k => v.id }
}

output "endpoints_eni_ids" {
  description = "Array containing the full resource object and attributes for all endpoints created"
  value       = { for k, v in aws_vpc_endpoint.this : k => v.network_interface_ids }
}

output "endpoints_eni_dns" {
  description = "Array containing the full resource object and attributes for all endpoints created"
  value       = { for k, v in aws_vpc_endpoint.this : k => v.dns_entry }
}
