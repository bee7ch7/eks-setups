# output "codedeploy_group_names" {
#   value = aws_codedeploy_deployment_group.this[0].deployment_group_name
# }

# output "codedeploy_group_configs" {
#   value = aws_codedeploy_deployment_group.this[0].deployment_config_name
# }

# output "codedeploy_apps" {
#   value = aws_codedeploy_app.this[0].name
# }

output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = try(module.iam_role[0].arn, "")
}

output "iam_role_name" {
  description = "Name of IAM role"
  value       = try(module.iam_role[0].name, "")
}

output "iam_role_path" {
  description = "Path of IAM role"
  value       = try(module.iam_role[0].path, "")
}

output "iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = try(module.iam_role[0].unique_id, "")
}

output "iam_instance_profile_arn" {
  description = "ARN of IAM instance profile"
  value       = try(module.iam_role[0].arn, "")
}

output "iam_instance_profile_name" {
  description = "Name of IAM instance profile"
  value       = try(module.iam_role[0].name, "")
}

output "iam_instance_profile_id" {
  description = "IAM Instance profile's ID."
  value       = try(module.iam_role[0].id, "")
}

output "iam_instance_profile_path" {
  description = "Path of IAM instance profile"
  value       = try(module.iam_role[0].path, "")
}

output "iam_policies" {
  value = try(module.iam_policies[0].list_of_policy_arns, [])
}
