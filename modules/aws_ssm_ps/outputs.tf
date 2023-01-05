output "ssm_parameter_arns" {
  value = { for k, v in aws_ssm_parameter.this : k => v.arn }
}

output "ssm_parameter_values" {
  value     = { for k, v in aws_ssm_parameter.this : k => v.value }
  sensitive = true
}
