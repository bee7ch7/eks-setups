variable "ecs_cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "ecs_appasg_list" {
  type = map(object({
    name             = string
    ecs_service_name = string
    max_capacity     = number
    min_capacity     = number
    cpu = object({
      name               = string
      target_value       = number
      scale_in_cooldown  = number
      scale_out_cooldown = number
    })
    memory = object({
      name               = string
      target_value       = number
      scale_in_cooldown  = number
      scale_out_cooldown = number
    })
  }))
}
