# variable "environment" {
#   description = "Environment"
# }

# variable "deployment_type" {
#   description = "Deployment type: ECS, CODE_DEPLOY"
#   default     = "ECS"
# }

variable "service_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "iam_role" {
  type = string
}

variable "task_definition" {
  type = string
}

variable "desired_count" {
  type = number
  default = 1
}

variable "deployment_minimum_healthy_percent" {
  type = number
  default = 50
}

variable "deployment_maximum_percent" {
  type = number
  default = 200
}

variable "launch_type" {
  type = string
  default = "EC2"
}

variable "load_balancer_enabled" {
  type = bool
  default = false
}

variable "health_check_grace_period_seconds" {
  type = number
  default = 0
}

variable "force_new_deployment" {
  type = bool
  default = false
}

variable "enable_execute_command" {
  type = bool
  default = false
}

variable "ecs_service_registries" {
  type = list(any)
}

variable "ecs_load_balancers" {
  type = list(any)
}

variable "network_mode" {
  type = string
  default = "bridge"
}

variable "security_groups" {
  type = list(any)
  default = []
}

variable "subnet_ids" {
  type = list(any)
  default = []
}

variable "assign_public_ip" {
  type = bool
  default = false
}

variable "deployment_type" {
  type = string
  default = "ECS"
}
