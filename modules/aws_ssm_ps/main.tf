resource "aws_ssm_parameter" "this" {
  for_each    = var.parameters
  name        = "/${var.environment}/${each.value.prefix}/${each.value.name}"
  description = each.value.description
  type        = each.value.type
  value       = try(each.value.value, random_password.this[each.key].result)

  # lifecycle {
  #   ignore_changes = [
  #     value
  #   ]
  # }
}

resource "random_password" "this" {
  for_each         = var.parameters
  length           = 16
  numeric          = true
  upper            = true
  lower            = true
  special          = true
  override_special = "!#$&*()-_=+[]{}<>:?"
}
