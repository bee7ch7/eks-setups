# variable "environment" {
#   description = "the name of your environment, e.g. \"prod\""
# }

# variable "name" {
#   type = string
# }

# variable "compute_platform" {
#   type    = string
#   default = "ECS"
# }

# variable "code_deploy_strategy" {
#   type = string
# }

variable "service_role_arn" {
  type    = string
  default = ""
}

# variable "create" {
#   type    = bool
#   default = true
# }

# variable "auto_rollback_configuration_events" {
#   type    = string
#   default = "DEPLOYMENT_FAILURE"
# }

# variable "trigger_events" {
#   type    = list(string)
#   default = ["DeploymentFailure"]
# }

# variable "trigger_name" {
#   type    = string
#   default = "Deployment status"
# }

# variable "load_balancer_info" {
#   type    = map(any)
#   default = null
# }

# variable "ecs_service" {
#   type = list(object({
#     cluster_name = string
#     service_name = string
#   }))
#   default = null
# }

# variable "deployment_style" {
#   type = object({
#     deployment_option = string
#     deployment_type   = string
#   })
#   default = null
# }

# variable "blue_green_deployment_config" {
#   type    = any
#   default = null
# }

# variable "sns_topic_arn" {
#   type    = string
#   default = null
# }

variable "tags" {
  type    = map(any)
  default = {}
}

#### IAM ####
variable "iam_role_name" {
  type    = string
  default = ""
}
variable "iam_role_requires_mfa" {
  type    = bool
  default = false
}
variable "iam_create_role" {
  type    = bool
  default = false
}
variable "iam_trusted_role_services" {
  type    = list(any)
  default = []
}

variable "iam_custom_role_policy_arns" {
  type    = list(any)
  default = []
}

variable "iam_policies_create" {
  type    = bool
  default = false
}

variable "iam_policies" {
  type    = map(any)
  default = {}
}
